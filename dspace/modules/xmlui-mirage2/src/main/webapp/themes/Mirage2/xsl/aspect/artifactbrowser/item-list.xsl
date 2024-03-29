<!--
    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at
    http://www.dspace.org/license/ --> <!--
    Rendering of a list of items (e.g. in a search or
    browse results page)
    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov --> <xsl:stylesheet
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:oreatom="http://www.openarchives.org/ore/atom/"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
    xmlns:confman="org.dspace.core.ConfigurationManager"
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util confman">
    <xsl:output indent="yes"/>
    <!--these templates are modfied to support the 2 different item list views that
    can be configured with the property 'xmlui.theme.mirage.item-list.emphasis' in dspace.cfg-->
    <xsl:template name="itemSummaryList-DIM">
        <xsl:variable name="itemWithdrawn" select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/@withdrawn" />
        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="$itemWithdrawn">
                    <xsl:value-of select="@OBJEDIT"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@OBJID"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="emphasis" select="confman:getProperty('xmlui.theme.mirage.item-list.emphasis')"/>
        <xsl:choose>
            <xsl:when test="'file' = $emphasis">
                <div class="item-wrapper row">
                    <div class="col-sm-3 hidden-xs">
                        <xsl:apply-templates select="./mets:fileSec" mode="artifact-preview">
                            <xsl:with-param name="href" select="$href"/>
                        </xsl:apply-templates>
                    </div>
                    <div class="col-sm-9">
                        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                                             mode="itemSummaryList-DIM-metadata">
                            <xsl:with-param name="href" select="$href"/>
                        </xsl:apply-templates>
                    </div>
                </div>
		<hr />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                                     mode="itemSummaryList-DIM-metadata"><xsl:with-param name="href" select="$href"/></xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--handles the rendering of a single item in a list in file mode-->
    <!--handles the rendering of a single item in a list in metadata mode-->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM-metadata">
        <xsl:param name="href"/>
        <div class="artifact-description">
            <div class="artifact-info">
                <span class="author h4">
                    <small>
	<xsl:choose>
	               <xsl:when test="dim:field[@element='type'] = 'courseDescription' or 
dim:field[@element='type'] = 'conferenceProg' or dim:field[@element='type'] = 'conferenceBoA' or dim:field[@element='type'] = 'conferenceCall' or 
dim:field[@element='type'] = 'conferencePaper'">
                        <xsl:if test="dim:field[@element='contributor'][@qualifier='organiser']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='organiser']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='organiser']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
			<xsl:if test="dim:field[@element='contributor'][@qualifier='organisertwo']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='organisertwo']">
                                <xsl:text>; </xsl:text><xsl:copy-of select="node()"/>
                            </xsl:for-each>
                        </xsl:if>
			<xsl:if test="dim:field[@element='contributor'][@qualifier='organiserthree']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='organiserthree']">
                                <xsl:text>; </xsl:text><xsl:copy-of select="node()"/>
                            </xsl:for-each>
                        </xsl:if>
                </xsl:when>
				<xsl:when test="dim:field[@element='type'] = 'syllabus' or dim:field[@element='type'] = 'lecture'">
                        <xsl:if test="dim:field[@element='contributor'][@qualifier='lecturer']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='lecturer']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='lecturer']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                </xsl:when>
		<xsl:otherwise>
			<xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='lecturer']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='lecturer']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='lecturer']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
			<xsl:when test="dim:field[@element='contributor'][@qualifier='editor'] and not(dim:field[@element='title'][@qualifier='specialissue'])">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
                                <xsl:copy-of select="node()"/>
                    	          <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='editor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
			
				<xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) = 1">
				 <i18n:text>xmlui.dri2xhtml.METS-1.0.item-editorone</i18n:text>
				</xsl:if>
				<xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) &gt; 1">
				 <i18n:text>xmlui.dri2xhtml.METS-1.0.item-editormult</i18n:text>
				</xsl:if>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='organiser']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='organiser']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='organiser']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise>
			</xsl:choose>
			</xsl:otherwise>
                    </xsl:choose>
                    </small>
                </span>
                <xsl:text> </xsl:text>
                <xsl:if test="dim:field[@element='date' and @qualifier='issued']">
	                <span class="publisher-date h4"> <small>
	                    <xsl:text>(</xsl:text>
	                    <!--<xsl:if test="dim:field[@element='publisher']">
	                        <span class="publisher">
	                            <xsl:copy-of select="dim:field[@element='publisher']/node()"/>
	                        </span>
	                        <xsl:text>, </xsl:text>
	                    </xsl:if>-->
	                    <span class="date">
	                        <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
	                    </span>
	                    <xsl:text>):</xsl:text>
                        </small></span>
                </xsl:if>
            </div>
            <!--<xsl:if test="dim:field[@element = 'description' and @qualifier='abstract']">
                <xsl:variable name="abstract" select="dim:field[@element = 'description' and @qualifier='abstract']/node()"/>
                <div class="artifact-abstract">
                    <xsl:value-of select="util:shortenString($abstract, 220, 10)"/>
                </div>
            </xsl:if>-->
	<xsl:choose>
	<xsl:when test="dim:field[@element='type'] = 'article' or dim:field[@element='type'] = 'review' or dim:field[@element='type'] = 
'dissertation' or dim:field[@element='type'] = 'lecture' or dim:field[@element='type'] = 'report'">
	<span class="artifact-title">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$href"/>
	                    </xsl:attribute>
	<xsl:choose>
                                <xsl:when test="count(dim:field[@element='title'][not(@qualifier)])">
                                <xsl:text>&quot;</xsl:text><xsl:value-of select="dim:field[@element='title'][not(@qualifier)]"/>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                                <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) !=
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" />
                                </xsl:if>
                                <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) !=
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'"><xsl:if
test="not(dim:field[@element='title'][@qualifier='alternative'])"><xsl:text>.</xsl:text></xsl:if></xsl:if>
                                <xsl:if test="substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '?' and substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '!' and substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '.'"><xsl:if
test="dim:field[@element='title'][@qualifier='alternative']"><xsl:text>.</xsl:text></xsl:if>
                                </xsl:if>
                                <xsl:text>&quot; </xsl:text></xsl:when>
                                <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                </xsl:otherwise>
                        </xsl:choose>

                </xsl:element>
                <span class="Z3988">
                    <xsl:attribute name="title">
                        <xsl:call-template name="renderCOinS"/>
                    </xsl:attribute>
<!--                    &#xFEFF; --><!-- non-breaking space to force separating the end tag -->
                </span>
            </span>
	</xsl:when>

	 <xsl:when test="dim:field[@element='type'] = 'courseDescription' or dim:field[@element='type'] = 'syllabus' or dim:field[@element='type'] = 
'conferenceReport' or dim:field[@element='type'] = 'conferenceProg' or dim:field[@element='type'] = 'conferenceBoA' or dim:field[@element='type'] = 
'conferenceCall' or dim:field[@element='type'] = 'conferencePaper' or dim:field[@element='type'] = 'cfppublication'">
        <span class="artifact-title"><i>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$href"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='title']">
                            <xsl:value-of select="dim:field[@element='title'][1]/node()"/>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                                <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '?' and substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
				<xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" />
 <xsl:if test="substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][not(@qualifier)])) != '?' and substring(dim:field[@element='title'][not(@qualifier)],
string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and substring(dim:field[@element='title'][not(@qualifier)],
string-length(dim:field[@element='title'][not(@qualifier)])) != '.'"><xsl:text>. </xsl:text></xsl:if>
                                </xsl:if>
                        <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '?' and substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '.' and not(dim:field[@element='title'][@qualifier='alternative'])"><xsl:text>. </xsl:text></xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <span class="Z3988">
                    <xsl:attribute name="title">
                        <xsl:call-template name="renderCOinS"/>
                    </xsl:attribute>
                   <!-- &#xFEFF; non-breaking space to force separating the end tag -->
                </span>
            </i></span>
        </xsl:when>
	
	<xsl:when test="dim:field[@element='type'] = 'anthologyArticle' or dim:field[@element='type'] = 'workingPaper' or dim:field[@element='type'] = 'blogentry'">
        <span class="artifact-title">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$href"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='title']">
                            <xsl:text>&quot;</xsl:text><xsl:value-of select="dim:field[@element='title'][1]/node()"/>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                                <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '?' and substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
				<xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" />
                                </xsl:if>
				<xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '?' and substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and substring(dim:field[@element='title'][not(@qualifier)], 
string-length(dim:field[@element='title'][not(@qualifier)])) != '.'"><xsl:if 
test="not(dim:field[@element='title'][@qualifier='alternative'])"><xsl:text>.</xsl:text></xsl:if></xsl:if>
                                <xsl:if test="substring(dim:field[@element='title'][@qualifier='alternative'], 
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '?' and substring(dim:field[@element='title'][@qualifier='alternative'], 
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '!' and substring(dim:field[@element='title'][@qualifier='alternative'], 
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '.'"><xsl:if 
test="dim:field[@element='title'][@qualifier='alternative']"><xsl:text>.</xsl:text></xsl:if>
                                </xsl:if>
                        <xsl:text>&quot; </xsl:text></xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <span class="Z3988">
                    <xsl:attribute name="title">
                        <xsl:call-template name="renderCOinS"/>
                    </xsl:attribute>
<!--                    &#xFEFF;  non-breaking space to force separating the end tag -->
                </span>
            </span>
        </xsl:when>
	<xsl:otherwise>
		<span class="artifact-title"><i>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$href"/>
                    </xsl:attribute>


<xsl:choose>
                                <xsl:when test="count(dim:field[@element='title'][not(@qualifier)])">
                                <xsl:value-of select="dim:field[@element='title'][not(@qualifier)]"/>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                                <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) !=
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" />
                                </xsl:if>
                                <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) !=
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'"><xsl:if
test="not(dim:field[@element='title'][@qualifier='alternative'])"><xsl:text>.</xsl:text></xsl:if></xsl:if>
                                <xsl:if test="substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '?' and substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '!' and substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '.'"><xsl:if
test="dim:field[@element='title'][@qualifier='alternative']"><xsl:text>.</xsl:text></xsl:if>
                                </xsl:if>
                                <xsl:text> </xsl:text></xsl:when>
                                <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                </xsl:otherwise>
                        </xsl:choose>




                </xsl:element>
                <span class="Z3988">
                    <xsl:attribute name="title">
                        <xsl:call-template name="renderCOinS"/>
                    </xsl:attribute>
<!--                    &#xFEFF;  non-breaking space to force separating the end tag -->
                </span>
            </i></span>
	</xsl:otherwise>
	</xsl:choose>
        
<xsl:choose> <xsl:when test="dim:field[@element='type'] = 'dissertation'">
				<xsl:if test="dim:field[@element='relation'][@qualifier='university']">
				<xsl:text> </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='university']" /><xsl:text>, </xsl:text>
                            </xsl:if>
				<xsl:if test="dim:field[@element='date'][@qualifier='submitted']">
                                <xsl:value-of select="dim:field[@element='date'][@qualifier='submitted']" /><xsl:text>. </xsl:text>
                            </xsl:if>
	                    <xsl:if test="dim:field[@element='publishedIn']">
				<xsl:value-of select="dim:field[@element='publishedIn']" /><xsl:text>: </xsl:text>
                            </xsl:if>
                            <xsl:if test="dim:field[@element='publisher']">
				<xsl:value-of select="dim:field[@element='publisher']" /><xsl:text>. </xsl:text>
                            </xsl:if>
                            <xsl:if test="dim:field[@element='relation'][@qualifier='ispartofseries']">
				<xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartofseries']">
                                <xsl:if test="contains(./node(), ';')">
                                <xsl:copy-of select="substring-before(./node(), ';')"/><xsl:copy-of select="substring-after(./node(), ';')"/>
                                </xsl:if>
                                <xsl:if test="not(contains(./node(), ';'))">
                                <xsl:copy-of select="./node()" />
                                </xsl:if>
                        </xsl:for-each>
			<xsl:text>.</xsl:text>
                            </xsl:if>
	</xsl:when>
	<xsl:when test="dim:field[@element='type'] = 'monograph'">
	                    <xsl:if test="dim:field[@element='publishedIn']">
				<xsl:value-of select="dim:field[@element='publishedIn']" /><xsl:text>: </xsl:text>
                            </xsl:if>
                            <xsl:if test="dim:field[@element='publisher']">
				<xsl:value-of select="dim:field[@element='publisher']" /><xsl:text>. </xsl:text>
                            </xsl:if>
                            <xsl:if test="dim:field[@element='relation'][@qualifier='ispartofseries']">
				<xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartofseries']">
                                <xsl:if test="contains(./node(), ';')">
                                <xsl:copy-of select="substring-before(./node(), ';')"/><xsl:copy-of select="substring-after(./node(), ';')"/>
                                </xsl:if>
                                <xsl:if test="not(contains(./node(), ';'))">
                                <xsl:copy-of select="./node()" />
                                </xsl:if>
                        </xsl:for-each>
			<xsl:text>.</xsl:text>
                            </xsl:if>
	</xsl:when>
	<xsl:when test="dim:field[@element='type'] = 'workingPaper'">
                           
                            <xsl:if test="dim:field[@element='relation'][@qualifier='volume']">
                               <i> 
				<xsl:if test="contains(dim:field[@element='relation'][@qualifier='volume'], ';')">
				<xsl:value-of select="substring-before(dim:field[@element='relation'][@qualifier='volume'], ';')" />
				</xsl:if>
				<xsl:if test="not(contains(dim:field[@element='relation'][@qualifier='volume'], ';'))">
                                <xsl:value-of select="dim:field[@element='relation'][@qualifier='volume']" />
                                </xsl:if>
				</i><xsl:text>. </xsl:text>
                            </xsl:if>
                             <xsl:if test="dim:field[@element='description'][@qualifier='institution']">
                       <xsl:value-of select="dim:field[@element='description'][@qualifier='institution']/node()"/><xsl:text>. </xsl:text>
                </xsl:if>
                            <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='volume']">
                         <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='volume']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='issue']">
                         <xsl:text>.</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='issue']/node()"/>
                </xsl:if>
                 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='article']">
                         <xsl:text>(</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='article']/node()"/>
						<xsl:text>)</xsl:text>
						  </xsl:if>
                 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                       <xsl:text>: </xsl:text> <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                         <xsl:text>&#150;</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']/node()"/><xsl:text>.
</xsl:text>
                </xsl:if>
        </xsl:when>



	<xsl:when test="dim:field[@element='type'] = 'anthology'">
		<xsl:if test="dim:field[@element='publishedIn']">
                                <xsl:value-of select="dim:field[@element='publishedIn']" /><xsl:text>: </xsl:text>
                            </xsl:if>
                            <xsl:if test="dim:field[@element='publisher']">
                                <xsl:value-of select="dim:field[@element='publisher']" /><xsl:text>. </xsl:text>
                            </xsl:if>

			<xsl:if test="dim:field[@element='relation'][@qualifier='ispartofseries']">
                                <xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartofseries']">
                                <xsl:if test="contains(./node(), ';')">
                                <xsl:copy-of select="substring-before(./node(), ';')"/><xsl:copy-of select="substring-after(./node(), ';')"/>
                                </xsl:if>
                                <xsl:if test="not(contains(./node(), ';'))">
                                <xsl:copy-of select="./node()" />
                                </xsl:if>
                        </xsl:for-each>
                        <xsl:text>. </xsl:text>
                            </xsl:if>
			<xsl:if test="not(dim:field[@element='relation'][@qualifier='ispartofseries']) and dim:field[@element='relation'][@qualifier='volume']">
                                <xsl:for-each select="dim:field[@element='relation' and @qualifier='volume']">
                                <xsl:if test="contains(./node(), ';')">
                                <xsl:copy-of select="substring-before(./node(), ';')"/><xsl:copy-of select="substring-after(./node(), ';')"/>
                                </xsl:if>
                                <xsl:if test="not(contains(./node(), ';'))">
                                <xsl:copy-of select="./node()" />
                                </xsl:if>
                        </xsl:for-each>
                        <xsl:text>. </xsl:text>
                            </xsl:if>
        </xsl:when>
		
		<xsl:when test="dim:field[@element='type'] = 'cfppublication'">
                            <xsl:if test="dim:field[@element='relation'][@qualifier='journal']">
                               <xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']" />
                            </xsl:if>
							<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='volume']">
                                <xsl:text> </xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='volume']" />
                            </xsl:if>
			    <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='issue']">
                                <xsl:text>.</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='issue']" 
/><xsl:text>. </xsl:text>
                            </xsl:if>
        </xsl:when>
		
	<xsl:when test="dim:field[@element='type'] = 'article' or dim:field[@element='type'] = 'review' or dim:field[@element='type'] = 
'digitalReproduction'">
			   <xsl:if test="dim:field[@element='relation'][@qualifier='reviewOf']">
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.reviewof</i18n:text><i><xsl:value-of 
select="dim:field[@element='relation'][@qualifier='reviewOf']" /></i><i18n:text>xmlui.dri2xhtml.METS-1.0.reviewofby</i18n:text>
                            </xsl:if>
			     <xsl:if test="dim:field[@element='relation'][@qualifier='reviewOfBy']">
	                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='reviewOfBy']">
                                <xsl:apply-templates select="." />
                                <xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='reviewOfBy']) != 0">
                                        <xsl:text>; </xsl:text>
        	                </xsl:if>
                	        </xsl:for-each>
                       	 	<xsl:text>. </xsl:text>
                	    </xsl:if>

<xsl:if test="dim:field[@element='title'][@qualifier='specialissue']">
                                <xsl:value-of
select="dim:field[@element='title'][@qualifier='specialissue']" /><xsl:text>. </xsl:text>
                </xsl:if>

<xsl:if test="dim:field[@element='contributor'][@qualifier='editor']">
                        <xsl:text>Ed. </xsl:text>
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
                                     <!--<xsl:apply-templates select="."/>-->
                                    <xsl:copy-of select="substring-after(., ', ')" /><xsl:text> </xsl:text>
                                    <xsl:copy-of select="substring-before(., ',')" />
                                    <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='editor']) != 0">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                        </xsl:for-each>
                        <xsl:text>. </xsl:text>
                </xsl:if>

<xsl:if test="dim:field[@element='title'][@qualifier='specialissue']">
                         <xsl:text>Special issue of </xsl:text>
                </xsl:if>
                            <xsl:if test="dim:field[@element='relation'][@qualifier='journal']">
                               <i><xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']" /></i>
                            </xsl:if>
			     <xsl:if test="dim:field[@element='relation'][@qualifier='journalalt']">
                               <i><xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='journalalt']" /></i>
                            </xsl:if>
				<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='volume']">
                       <xsl:text> </xsl:text> <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='volume']/node()"/>
                </xsl:if>
				<xsl:if test="not(dim:field[@element='bibliographicCitation'][@qualifier='issue']) and not(dim:field[@element='bibliographicCitation'][@qualifier='article']) and not(dim:field[@element='bibliographicCitation'][@qualifier='firstPage'])">
				<xsl:text>.</xsl:text>
				</xsl:if>
				
				<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='issue'] or dim:field[@element='bibliographicCitation'][@qualifier='article'] or dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">

               <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='issue']">
                         <xsl:text>.</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='issue']/node()"/>
                </xsl:if>
				<xsl:if test="not(dim:field[@element='bibliographicCitation'][@qualifier='article']) and not(dim:field[@element='bibliographicCitation'][@qualifier='firstPage'])">
				<xsl:text>.</xsl:text>
				</xsl:if>
				
				<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='article'] or dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">

                 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='article']">
                         <xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='article']/node()"/>
                </xsl:if>
				<xsl:if test="not(dim:field[@element='bibliographicCitation'][@qualifier='firstPage'])">
				<xsl:text>.</xsl:text>
				</xsl:if>
                 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                       <xsl:text>: </xsl:text> <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                         <xsl:text>&#150;</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']/node()"/><xsl:text>.</xsl:text>
                </xsl:if>
				</xsl:if>

				</xsl:if>





        </xsl:when>
	<xsl:when test="dim:field[@element='type'] = 'report'">
	<xsl:if test="dim:field[@element='relation'][@qualifier='journal']">
                        <i><xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']/node()"/></i>

                         <xsl:if test="dim:field[@element='relation'][@qualifier='journalalt']">
                        <i><xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='journalalt']/node()"/></i>
                        </xsl:if>
                        <xsl:text>. </xsl:text>
                 </xsl:if>
                <xsl:if test="dim:field[@element='contributor'][@qualifier='editor']">
                        <xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) = 1">
                        <xsl:text>Ed. </xsl:text>
                        </xsl:if>

                        <xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) &gt; 1">
                         <xsl:text>Eds. </xsl:text>
                        </xsl:if>
                        <xsl:if test="contains(dim:field[@element='contributor'][@qualifier='editor'], ', ')">
                        <xsl:value-of select="substring-after(dim:field[@element='contributor'][@qualifier='editor']/node(), ', ')"/><xsl:text> </xsl:text>
                        <xsl:value-of select="substring-before(dim:field[@element='contributor'][@qualifier='editor']/node(), ', ')"/>
                        </xsl:if>
                        <xsl:if test="not(contains(dim:field[@element='contributor'][@qualifier='editor'], ', '))">
                        <xsl:value-of select="dim:field[@element='contributor'][@qualifier='editor']/node()"/>
                        </xsl:if>
                        <xsl:text>. </xsl:text>
                </xsl:if>


                 <xsl:if test="dim:field[@element='publishedIn']">
                        <xsl:value-of select="dim:field[@element='publishedIn']/node()"/><xsl:text>: </xsl:text>
                </xsl:if>
                 <xsl:if test="dim:field[@element='publisher']">
                        <xsl:value-of select="dim:field[@element='publisher']/node()"/><xsl:text>. </xsl:text>
                </xsl:if>

                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='volume']">
                        <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='volume']/node()"/>
                        <xsl:if test="not(dim:field[@element='bibliographicCitation'][@qualifier='firstPage'])"><xsl:text>. </xsl:text></xsl:if>
			<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']"><xsl:text>: </xsl:text></xsl:if>
                 </xsl:if>
		<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                       <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                         <xsl:text>&#150;</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']/node()"/><xsl:text>.</xsl:text>
                </xsl:if>



        </xsl:when>




	<xsl:when test="dim:field[@element='type'] = 'courseDescription' or dim:field[@element='type'] = 'syllabus'">
                            <xsl:if test="dim:field[@element='description'][@qualifier='seminar']">
                                <xsl:value-of select="dim:field[@element='description'][@qualifier='seminar']" /><xsl:text>. </xsl:text>
                            </xsl:if>
                            <xsl:if test="dim:field[@element='description'][@qualifier='location']">
                                <xsl:value-of select="dim:field[@element='description'][@qualifier='location']" />
                            </xsl:if>
                            <xsl:if test="dim:field[@element='description'][@qualifier='institution']">
                                <xsl:text>, </xsl:text><xsl:value-of select="dim:field[@element='description'][@qualifier='institution']" />
                            </xsl:if>
                            <xsl:if test="dim:field[@element='description'][@qualifier='semester']">
                                <xsl:text>, </xsl:text><xsl:value-of select="dim:field[@element='description'][@qualifier='semester']" /><xsl:text>. 
</xsl:text>
                            </xsl:if>
        </xsl:when>

<xsl:when test="dim:field[@element='type'] = 'conferenceReport'"> 
<xsl:if test="dim:field[@element='relation'][@qualifier='eventLocation']">
                        <xsl:value-of select="dim:field[@element='relation'][@qualifier='eventLocation']/node()"/><xsl:text>, </xsl:text>
                </xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='eventStart']">
                        <xsl:copy-of select="substring(dim:field[@element='relation'][@qualifier='eventStart']/node(),9,2)"/><xsl:text>.</xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventStart']/node(),6,2)"/><xsl:text>.</xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventStart']/node(),1,4)"/>
                </xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='eventEnd']">
                        <xsl:text> - </xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventEnd']/node(),9,2)"/><xsl:text>.</xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventEnd']/node(),6,2)"/><xsl:text>.</xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventEnd']/node(),1,4)"/>
                </xsl:if>
		<xsl:text>. </xsl:text>
            
            
            
            
            <xsl:choose>
				   <xsl:when test="dim:field[@element='contributor'][@qualifier='organiser']">
				<xsl:for-each select="dim:field[@element='contributor'][@qualifier='organiser']">
				<a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', .)" /></xsl:attribute>
				 <xsl:value-of select="./node()"/> <xsl:if test="count(following-sibling::dim:field[@element='contributor' and 
@qualifier='organiser']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                                </a>
				</xsl:for-each>
                        </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-organiser</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
                                   <xsl:if test="dim:field[@element='contributor'][@qualifier='organisertwo']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='organisertwo']"><xsl:text>, </xsl:text>
                                <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', .)" /></xsl:attribute>
                                 <xsl:value-of select="./node()"/> <xsl:if test="count(following-sibling::dim:field[@element='contributor' and
@qualifier='organisertwo']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                                </a>
                                </xsl:for-each>
			</xsl:if>
                                   <xsl:if test="dim:field[@element='contributor'][@qualifier='organiserthree']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='organiserthree']"><xsl:text>, </xsl:text>
                                <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', .)" /></xsl:attribute>
                                 <xsl:value-of select="./node()"/> <xsl:if test="count(following-sibling::dim:field[@element='contributor' and
@qualifier='organiserthree']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                                </a>
                                </xsl:for-each><xsl:text>. </xsl:text>
                        </xsl:if>
		<xsl:if test="dim:field[@element='contributor'][@qualifier='organizedBy']">
			<xsl:text>. </xsl:text>
                        <i18n:text>xmlui.dri2xhtml.organizedBy</i18n:text>
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='organizedBy']">
                                     <!--<xsl:apply-templates select="."/>-->
				    <xsl:copy-of select="substring-after(., ', ')" /><xsl:text> </xsl:text>
				    <xsl:copy-of select="substring-before(., ',')" />
                                    <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='organizedBy']) != 0">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                        </xsl:for-each>
                        <xsl:text>. </xsl:text>


	        </xsl:if>

<xsl:if test="dim:field[@element='relation'][@qualifier='journal']">
                               <i><xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']" /></i>
                            </xsl:if>
			     <xsl:if test="dim:field[@element='relation'][@qualifier='journalalt']">
                               <i><xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='journalalt']" /></i>
                            </xsl:if>
				<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='volume']">
                       <xsl:text> </xsl:text> <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='volume']/node()"/>
                </xsl:if>
				
				<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='issue'] or dim:field[@element='bibliographicCitation'][@qualifier='article'] or dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">

               <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='issue']">
                         <xsl:text>.</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='issue']/node()"/>
                </xsl:if>
				
				<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='article'] or dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">

                 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='article']">
                         <xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='article']/node()"/>
                </xsl:if>
				<xsl:if test="not(dim:field[@element='bibliographicCitation'][@qualifier='firstPage'])">
				<xsl:text>.</xsl:text>
				</xsl:if>
                 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                       <xsl:text>: </xsl:text> <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                         <xsl:text>&#150;</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']/node()"/><xsl:text>.</xsl:text>
                </xsl:if>
				</xsl:if>


</xsl:if>
</xsl:when>


	 <xsl:when test="dim:field[@element='type'] = 'conferenceProg' or dim:field[@element='type'] 
= 'conferenceBoA' or dim:field[@element='type'] = 'conferenceCall' or dim:field[@element='type'] = 'conferencePaper' or dim:field[@element='type'] = 'lecture'">
			<xsl:if test="dim:field[@element='relation'][@qualifier='eventLocation']">
                               <xsl:value-of select="dim:field[@element='relation'][@qualifier='eventLocation']" /><xsl:text>, </xsl:text>
                        </xsl:if>
			 <!--<xsl:if test="dim:field[@element='relation'][@qualifier='eventStart']">
                               <xsl:value-of select="dim:field[@element='relation'][@qualifier='eventStart']" />
                        </xsl:if>
			 <xsl:if test="dim:field[@element='relation'][@qualifier='eventEnd']">
                               <xsl:text> - </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='eventEnd']" /><xsl:text>. 
</xsl:text>
                        </xsl:if>-->
			<xsl:if test="dim:field[@element='relation'][@qualifier='eventStart']">
                        <xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventStart']/node(),9,2)"/><xsl:text>.</xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventStart']/node(),6,2)"/><xsl:text>.</xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventStart']/node(),1,4)"/>
	                </xsl:if>
        	        <xsl:if test="dim:field[@element='relation'][@qualifier='eventEnd']">
                        <xsl:text> - </xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventEnd']/node(),9,2)"/><xsl:text>.</xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventEnd']/node(),6,2)"/><xsl:text>.</xsl:text><xsl:copy-of 
select="substring(dim:field[@element='relation'][@qualifier='eventEnd']/node(),1,4)"/>
                	</xsl:if>
                	<xsl:text>. </xsl:text>
			 <xsl:if test="dim:field[@element='contributor'][@qualifier='organizedBy']">
                        <i18n:text>xmlui.dri2xhtml.organizedBy</i18n:text>
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='organizedBy']">
				<xsl:copy-of select="substring-after(., ', ')" /><xsl:text> </xsl:text>
                                    <xsl:copy-of select="substring-before(., ',')" />
                                    <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='organizedBy']) != 0">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                        </xsl:for-each>
                        <xsl:text>. </xsl:text>
			<xsl:if test="dim:field[@element='relation'][@qualifier='journal']">
                        <i><xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']/node()"/></i>

                         <xsl:if test="dim:field[@element='relation'][@qualifier='journalalt']">
                        <i><xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='journalalt']/node()"/></i>
                        </xsl:if>
                        <xsl:text>. </xsl:text>
                 </xsl:if>

                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='volume']">
                        <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='volume']/node()"/>
                        <xsl:if test="not(dim:field[@element='bibliographicCitation'][@qualifier='firstPage'])"><xsl:text>. </xsl:text></xsl:if>
			<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']"><xsl:text>: </xsl:text></xsl:if>
                 </xsl:if>
		<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                       <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                         <xsl:text>&#150;</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']/node()"/><xsl:text>.</xsl:text>
                </xsl:if>



        </xsl:if>
<xsl:if test="dim:field[@element='type'] = 'lecture'">
<xsl:if test="dim:field[@element='relation'][@qualifier='editor']">
			 <xsl:if test="count(dim:field[@element='relation'][@qualifier='editor']) = 1">
                         <i18n:text>xmlui.dri2xhtml.METS-1.0.editorone</i18n:text>
                        </xsl:if>
                        <xsl:if test="count(dim:field[@element='relation'][@qualifier='editor']) &gt; 1">
                         <i18n:text>xmlui.dri2xhtml.METS-1.0.editormult</i18n:text>
                        </xsl:if>
			<xsl:for-each select="dim:field[@element='relation'][@qualifier='editor']">
                        <xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='editor']) = 0 and 
count(preceding-sibling::dim:field[@element='relation' and @qualifier='editor']) != 0"><i18n:text>xmlui.dri2xhtml.METS-1.0.lasteditor</i18n:text></xsl:if>
                            <xsl:value-of select="substring-after(./node(), ', ')"/><xsl:text> </xsl:text><xsl:value-of select="substring-before(./node(), ',')"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='editor']) != 0 and 
count(following-sibling::dim:field[@element='relation' and @qualifier='editor']) != 1">
                        <xsl:text>, </xsl:text>
                        </xsl:if>
                        </xsl:for-each>
                        <xsl:text>. </xsl:text>
		</xsl:if>						
		<xsl:if test="dim:field[@element='publishedIn']">
                         <xsl:value-of select="dim:field[@element='publishedIn']/node()"/><xsl:text>: </xsl:text>
                </xsl:if>
                                <xsl:if test="dim:field[@element='publisher']">
                         <xsl:value-of select="dim:field[@element='publisher']/node()"/><xsl:text>. </xsl:text>
                </xsl:if>
<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                                <xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']" 
/><xsl:text>&#150;</xsl:text>
                            </xsl:if>
                     	    <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                                <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']" /><xsl:text>.</xsl:text>
                            </xsl:if>
<xsl:if test="dim:field[@element='relation'][@qualifier='ispartofseries']">
				<xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartofseries']">
                                <xsl:if test="contains(./node(), ';')">
                                <xsl:copy-of select="substring-before(./node(), ';')"/><xsl:copy-of select="substring-after(./node(), ';')"/>
                                </xsl:if>
                                <xsl:if test="not(contains(./node(), ';'))">
                                <xsl:copy-of select="./node()" />
                                </xsl:if>
                        	</xsl:for-each>
				<xsl:text>.</xsl:text>
                            </xsl:if>
<xsl:if test="not(dim:field[@element='relation'][@qualifier='ispartofseries']) and dim:field[@element='relation'][@qualifier='volume']">
                                <xsl:for-each select="dim:field[@element='relation' and @qualifier='volume']">
                                <xsl:if test="contains(./node(), ';')">
                                <xsl:copy-of select="substring-before(./node(), ';')"/><xsl:copy-of select="substring-after(./node(), ';')"/>
                                </xsl:if>
                                <xsl:if test="not(contains(./node(), ';'))">
                                <xsl:copy-of select="./node()" />
                                </xsl:if>
                                </xsl:for-each>
                                <xsl:text>.</xsl:text>
                            </xsl:if>

</xsl:if>
</xsl:when>



	<xsl:when test="dim:field[@element='type'] = 'anthologyArticle' or dim:field[@element='type'] = 'blogentry'">
                            <xsl:if test="dim:field[@element='relation'][@qualifier='ispartof']">
                               <i> <xsl:value-of select="dim:field[@element='relation'][@qualifier='ispartof']" />
				<xsl:if test="dim:field[@element='relation'][@qualifier='ispartofalt']"><xsl:text>: </xsl:text></xsl:if>
				<xsl:value-of select="dim:field[@element='relation'][@qualifier='ispartofalt']" /></i>
				<xsl:text>. </xsl:text>
                            </xsl:if>
			<xsl:if test="dim:field[@element='description'][@qualifier='institution']">
                       <xsl:value-of select="dim:field[@element='description'][@qualifier='institution']/node()"/><xsl:text>. </xsl:text>
                </xsl:if>
		    <xsl:if test="dim:field[@element='relation'][@qualifier='editor']">
			 <xsl:if test="count(dim:field[@element='relation'][@qualifier='editor']) = 1">
                         <i18n:text>xmlui.dri2xhtml.METS-1.0.editorone</i18n:text>
                        </xsl:if>
                        <xsl:if test="count(dim:field[@element='relation'][@qualifier='editor']) &gt; 1">
                         <i18n:text>xmlui.dri2xhtml.METS-1.0.editormult</i18n:text>
                        </xsl:if>
			<xsl:for-each select="dim:field[@element='relation'][@qualifier='editor']">
                        <xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='editor']) = 0 and 
count(preceding-sibling::dim:field[@element='relation' and @qualifier='editor']) != 
0"><i18n:text>xmlui.dri2xhtml.METS-1.0.lasteditor</i18n:text></xsl:if>
                            <xsl:value-of select="substring-after(./node(), ', ')"/><xsl:text> </xsl:text><xsl:value-of 
select="substring-before(./node(), ',')"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='editor']) != 0 and 
count(following-sibling::dim:field[@element='relation' and @qualifier='editor']) != 1">
                        <xsl:text>, </xsl:text>
                        </xsl:if>
                        </xsl:for-each>
                        <xsl:text>. </xsl:text>
		</xsl:if>
			<xsl:if test="dim:field[@element='date'][@qualifier='blog']">
                        <xsl:copy-of
select="substring(dim:field[@element='date'][@qualifier='blog']/node(),9,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring(dim:field[@element='date'][@qualifier='blog']/node(),6,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring(dim:field[@element='date'][@qualifier='blog']/node(),1,4)"/><xsl:text>.</xsl:text>
                        </xsl:if>
		
                            <xsl:if test="dim:field[@element='publishedIn']">
                                <xsl:text> </xsl:text><xsl:value-of select="dim:field[@element='publishedIn']" /><xsl:text>: </xsl:text>
                            </xsl:if>
			    <xsl:if test="dim:field[@element='publisher']">
                                <xsl:value-of select="dim:field[@element='publisher']" />
                            </xsl:if>
                            <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                                <xsl:text>, </xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']" 
/><xsl:text>&#150;</xsl:text>
                            </xsl:if>
                            <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                                <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']" /><xsl:text>. </xsl:text>
                            </xsl:if>
				<xsl:if test="dim:field[@element='relation'][@qualifier='ispartofseries']">
				<xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartofseries']">
                                <xsl:if test="contains(./node(), ';')">
                                <xsl:copy-of select="substring-before(./node(), ';')"/><xsl:copy-of select="substring-after(./node(), ';')"/>
                                </xsl:if>
                                <xsl:if test="not(contains(./node(), ';'))">
                                <xsl:copy-of select="./node()" />
                                </xsl:if>
                        	</xsl:for-each>
				<xsl:text>.</xsl:text>
                            </xsl:if>
			 <xsl:if test="not(dim:field[@element='relation'][@qualifier='ispartofseries']) and dim:field[@element='relation'][@qualifier='volume']">
                                <xsl:for-each select="dim:field[@element='relation' and @qualifier='volume']">
                                <xsl:if test="contains(./node(), ';')">
                                <xsl:copy-of select="substring-before(./node(), ';')"/><xsl:copy-of select="substring-after(./node(), ';')"/>
                                </xsl:if>
                                <xsl:if test="not(contains(./node(), ';'))">
                                <xsl:copy-of select="./node()" />
                                </xsl:if>
                                </xsl:for-each>
                                <xsl:text>.</xsl:text>
                            </xsl:if>
        </xsl:when> </xsl:choose>


<xsl:if test="dim:field[@element='type'] = 'lecture'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypelecture</i18n:text></div>
        </xsl:if>	
	<xsl:if test="dim:field[@element='type'] = 'review'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypereview</i18n:text></div>
        </xsl:if>
	 <xsl:if test="dim:field[@element='type'] = 'report'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypereport</i18n:text></div>
        </xsl:if>
	<xsl:if test="dim:field[@element='type'] = 'workingPaper'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeworkingpaper</i18n:text></div>
        </xsl:if>

	<xsl:if test="dim:field[@element='type'] = 'monograph'">
		<div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypemono</i18n:text></div>
	</xsl:if>
	<xsl:if test="dim:field[@element='type'] = 'dissertation'">
		<div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypedissertation</i18n:text></div>
	</xsl:if>
	<xsl:if test="dim:field[@element='type'] = 'article'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypearticle</i18n:text></div>
        </xsl:if>
	<xsl:if test="dim:field[@element='type'] = 'anthology'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeantho</i18n:text></div>
        </xsl:if>
	<xsl:if test="dim:field[@element='type'] = 'anthologyArticle'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeanthoarticle</i18n:text></div>
        </xsl:if>
	<xsl:if test="dim:field[@element='type'] = 'blogentry'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeblogentry</i18n:text></div>
        </xsl:if>
	 <xsl:if test="dim:field[@element='type'] = 'digitalReproduction'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypedigital</i18n:text></div>
        </xsl:if>
	<xsl:if test="dim:field[@element='type'] = 'courseDescription'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypecoursedesc</i18n:text></div>
        </xsl:if>
	<xsl:if test="dim:field[@element='type'] = 'syllabus'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypesyllabus</i18n:text></div>
        </xsl:if>
	<xsl:if test="dim:field[@element='type'] = 'conferenceReport'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfreport</i18n:text></div>
        </xsl:if>
        <xsl:if test="dim:field[@element='type'] = 'conferenceProg'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfprog</i18n:text></div>
        </xsl:if>
	 <xsl:if test="dim:field[@element='type'] = 'conferenceCall'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfcall</i18n:text></div>
        </xsl:if>
        <xsl:if test="dim:field[@element='type'] = 'conferenceBoA'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfboa</i18n:text></div>
        </xsl:if>
	 <xsl:if test="dim:field[@element='type'] = 'conferencePaper'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfpaper</i18n:text></div>
        </xsl:if>
		 <xsl:if test="dim:field[@element='type'] = 'cfppublication'">
                <div class="dctype"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypecfppublication</i18n:text></div>
        </xsl:if>
        </div>
    </xsl:template>
    <xsl:template name="itemDetailList-DIM">
        <xsl:call-template name="itemSummaryList-DIM"/>
    </xsl:template>
    <xsl:template match="mets:fileSec" mode="artifact-preview">
        <xsl:param name="href"/>
        <div class="thumbnail artifact-preview">
            <a class="image-link" href="{$href}">
                <xsl:choose>
                    <xsl:when test="mets:fileGrp[@USE='THUMBNAIL']">
                        <img class="img-responsive" alt="xmlui.mirage2.item-list.thumbnail" i18n:attr="alt">
                            <xsl:attribute name="src">
                                <xsl:value-of
                                        select="mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                        </img>
                    </xsl:when>
                    <xsl:otherwise>
                        <img alt="xmlui.mirage2.item-list.thumbnail" i18n:attr="alt">
                            <xsl:attribute name="data-src">
                                <xsl:text>holder.js/100%x</xsl:text>
                                <xsl:value-of select="$thumbnail.maxheight"/>
                                <xsl:text>/text:No Thumbnail</xsl:text>
                            </xsl:attribute>
                        </img>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </div>
    </xsl:template>
    <!--
        Rendering of a list of items (e.g. in a search or
        browse results page)
        Author: art.lowel at atmire.com
        Author: lieven.droogmans at atmire.com
        Author: ben at atmire.com
        Author: Alexey Maslov
    -->
        <!-- Generate the info about the item from the metadata section -->
        <xsl:template match="dim:dim" mode="itemSummaryList-DIM">
            <xsl:variable name="itemWithdrawn" select="@withdrawn" />
            <div class="artifact-description">
                <div class="artifact-title">
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="$itemWithdrawn">
                                    <xsl:value-of select="ancestor::mets:METS/@OBJEDIT" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="ancestor::mets:METS/@OBJID" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='title']">
                                <xsl:value-of select="dim:field[@element='title'][1]/node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </div>
                <span class="Z3988">
                    <xsl:attribute name="title">
                        <xsl:call-template name="renderCOinS"/>
                    </xsl:attribute>
                    &#xFEFF; <!-- non-breaking space to force separating the end tag -->
                </span>
                <div class="artifact-info">
                    <span class="author">
                        <xsl:choose>
                            <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                    <span>
                                        <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                        </xsl:if>
                                        <xsl:copy-of select="node()"/>
                                    </span>
                                    <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='creator']">
                                <xsl:for-each select="dim:field[@element='creator']">
                                    <xsl:copy-of select="node()"/>
                                    <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="dim:field[@element='contributor']">
                                <xsl:for-each select="dim:field[@element='contributor']">
                                    <xsl:copy-of select="node()"/>
                                    <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                    <xsl:text> </xsl:text>
                    <xsl:if test="dim:field[@element='date' and @qualifier='issued'] or dim:field[@element='publisher']">
                        <span class="publisher-date">
                            <xsl:text>(</xsl:text>
                            <xsl:if test="dim:field[@element='publisher']">
                                <span class="publisher">
                                    <xsl:copy-of select="dim:field[@element='publisher']/node()"/>
                                </span>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <span class="date">
                                <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
                            </span>
                            <xsl:text>)</xsl:text>
                        </span>
                    </xsl:if>
                </div>
            </div>
        </xsl:template> </xsl:stylesheet>
