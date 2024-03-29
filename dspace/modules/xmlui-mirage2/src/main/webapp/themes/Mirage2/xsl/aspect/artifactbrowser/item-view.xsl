<!--
    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at
    http://www.dspace.org/license/ --> <!--
    Rendering specific to the item display page.
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
    xmlns:jstring="java.lang.String"
    xmlns:rights="http://cosimo.stanford.edu/sdr/metsrights/"
    xmlns:confman="org.dspace.core.ConfigurationManager"
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util jstring rights confman">
    <xsl:output indent="yes"/>
    <xsl:template name="itemSummaryView-DIM">
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
        mode="itemSummaryView-DIM"/>
       <xsl:copy-of select="$SFXLink" />
        <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default)-->
        <!--<xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
            <div class="license-info table">
                <p>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text>
                </p>
                <ul class="list-unstyled">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']" mode="simple"/>
                </ul>
            </div>
        </xsl:if>-->
	
    </xsl:template>
    <!-- An item rendered in the detailView pattern, the "full item record" view of a DSpace item in Manakin. -->
    <xsl:template name="itemDetailView-DIM">
        <!-- Output all of the metadata about the item from the metadata section -->
        <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                             mode="itemDetailView-DIM"/>
        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h3>
                <div class="file-list">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE' or @USE='CC-LICENSE']">
                        <xsl:with-param name="context" select="."/>
                        <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE']" mode="itemDetailView-DIM" />
            </xsl:when>
            <xsl:otherwise>
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                    </tr>
                </table>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        <div class="item-summary-view-metadata">
	<xsl:choose>
		<!--Monograph-->
          <xsl:when test="dim:field[@element='type'] = 'monograph'">
                <!--<xsl:call-template name="itemSummaryView-DIM-title"/>-->
                <div class="itemview-citation">
            <xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or 
dim:field[@element='contributor' and descendant::text()]">
                   <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                        <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C', 
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </a>
			<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='author']) != 0">
			<xsl:text>; </xsl:text>
			</xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='creator']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='contributor']">
                        <xsl:for-each select="dim:field[@element='contributor']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
			</xsl:if>
			 <xsl:text> </xsl:text>
			<xsl:call-template name="itemSummaryView-DIM-date"/>


<xsl:choose>
                                <xsl:when test="count(dim:field[@element='title'][not(@qualifier)])">
                    <i>            <xsl:value-of select="dim:field[@element='title'][not(@qualifier)]"/></i>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                                <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) !=
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
<i>                                <xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" /></i>
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




                <xsl:call-template name="itemSummaryView-DIM-publishedIn"/><xsl:call-template name="itemSummaryView-DIM-publisher"/>
                <xsl:call-template name="itemSummaryView-DIM-ispartofseries"/>
		</div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypemono</i18n:text></div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/> <!-- <xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
		<xsl:call-template name="itemSummaryView-subjects"/>
                <!--<div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Monograph-->

<!--Arbeitspapier-->
          <xsl:when test="dim:field[@element='type'] = 'workingPaper'">
                <div class="itemview-citation">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or
dim:field[@element='contributor' and descendant::text()]">
                   <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                        <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C',
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='author']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='creator']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='contributor']">
                        <xsl:for-each select="dim:field[@element='contributor']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
                        </xsl:if>
                         <xsl:text> </xsl:text>
                        <xsl:call-template name="itemSummaryView-DIM-date"/>
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
                         <xsl:text> (</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='article']/node()"/>
						<xsl:text>)</xsl:text>
						  </xsl:if>
                 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                       <xsl:text>: </xsl:text> <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                         <xsl:text>&#150;</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']/node()"/><xsl:text>.
</xsl:text>
                </xsl:if>
                </div>
        <div class="itemview-citation-small">
        
        <xsl:if test="dim:field[@element='type'] = 'workingPaper'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeworkingpaper</i18n:text>
        </xsl:if>
        </div>

		  <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/>
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
                <!--<xsl:call-template name="itemSummaryView-collections"/>-->
                <xsl:call-template name="itemSummaryView-subjects"/>
                <!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
                <xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Arbeitspapier-->







 <!--Report-->
          <xsl:when test="dim:field[@element='type'] = 'report'">
		<div class="itemview-citation">
		<xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or 
dim:field[@element='contributor' and descendant::text()]">
                   <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                        <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C', 
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='author']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='creator']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='contributor']">
                        <xsl:for-each select="dim:field[@element='contributor']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
                        </xsl:if>
                         <xsl:text> </xsl:text>
                        <xsl:call-template name="itemSummaryView-DIM-date"/>
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
		
		<xsl:if test="dim:field[@element='relation'][@qualifier='journal']">
			<i><xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']/node()"/></i>
		
			 <xsl:if test="dim:field[@element='relation'][@qualifier='journalalt']"><i>
                        <xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='journalalt']/node()"/></i>
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

                </div>
        <div class="itemview-citation-small">
	<xsl:if test="dim:field[@element='type'] = 'report'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.dctypereport</i18n:text>
        </xsl:if>
        
	</div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/>
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
                <!--<xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-subjects"/>
		<!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Report-->


 <!--Dissertation-->
          <xsl:when test="dim:field[@element='type'] = 'dissertation'">
                <div class="itemview-citation">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or
dim:field[@element='contributor' and descendant::text()]">
                   <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                        <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C',
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='author']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='creator']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='contributor']">
                        <xsl:for-each select="dim:field[@element='contributor']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
                        </xsl:if>
                         <xsl:text> </xsl:text>
                        <xsl:call-template name="itemSummaryView-DIM-date"/>
                         <xsl:choose>
                                <xsl:when test="count(dim:field[@element='title'][not(@qualifier)])">
                                <i><xsl:value-of select="dim:field[@element='title'][not(@qualifier)]"/></i>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
                                <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) !=
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <i><xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" /></i>
                                </xsl:if>
                                <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) !=
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'"><xsl:if
test="not(dim:field[@element='title'][@qualifier='alternative'])"><xsl:text>. </xsl:text></xsl:if></xsl:if>
                                <xsl:if test="substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '?' and substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '!' and substring(dim:field[@element='title'][@qualifier='alternative'],
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '.'"><xsl:if
test="dim:field[@element='title'][@qualifier='alternative']"><xsl:text>. </xsl:text></xsl:if>
                                </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                </xsl:otherwise>
                        </xsl:choose>
                
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
                        <xsl:text>. </xsl:text></xsl:if>
				
				

                </div>
        <div class="itemview-citation-small">
        <xsl:if test="dim:field[@element='type'] = 'dissertation'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.dctypedissertation</i18n:text>
        </xsl:if>


        </div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/>
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
                <!--<xsl:call-template name="itemSummaryView-collections"/>-->
                <xsl:call-template name="itemSummaryView-subjects"/>
                <!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
                <xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Dissertation-->








<!--Lecture-->
          <xsl:when test="dim:field[@element='type'] = 'lecture'">
		<div class="itemview-citation">
		<xsl:if test="dim:field[@element='contributor'][@qualifier='lecturer' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or 
dim:field[@element='contributor' and descendant::text()]">
                   <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='lecturer']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='lecturer']">
                        <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C', 
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='lecturer']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='creator']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='contributor']">
                        <xsl:for-each select="dim:field[@element='contributor']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
                        </xsl:if>
                         <xsl:text> </xsl:text>
                        <xsl:call-template name="itemSummaryView-DIM-date"/>
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
		
		<xsl:if test="dim:field[@element='contributor'][@qualifier='organizedBy']">
			<xsl:value-of select="dim:field[@element='contributor'][@qualifier='organizedBy']/node()"/><xsl:text>. </xsl:text>
		</xsl:if>
		 <xsl:if test="dim:field[@element='relation'][@qualifier='eventLocation']">
                        <xsl:value-of select="dim:field[@element='relation'][@qualifier='eventLocation']/node()"/>
                </xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='eventStart']">
                       <xsl:text>, </xsl:text> <xsl:value-of select="dim:field[@element='relation'][@qualifier='eventStart']/node()"/><xsl:text>. </xsl:text>
                </xsl:if>
		<xsl:if test="dim:field[@element='contributor'][@qualifier='editor']">
                         <xsl:value-of select="dim:field[@element='contributor'][@qualifier='editor']/node()"/><xsl:text>. </xsl:text>
                </xsl:if>
		 <xsl:if test="dim:field[@element='publishedIn']">
                         <xsl:value-of select="dim:field[@element='publishedIn']/node()"/><xsl:text>: </xsl:text>
                </xsl:if>
				<xsl:if test="dim:field[@element='publisher']">
                         <xsl:value-of select="dim:field[@element='publisher']/node()"/><xsl:text>. </xsl:text>
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
		 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                       <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                         <xsl:text> - </xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']/node()"/><xsl:text>. 
</xsl:text>
                </xsl:if>
                </div>
        <div class="itemview-citation-small">
	<xsl:if test="dim:field[@element='type'] = 'lecture'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.dctypelecture</i18n:text>
        </xsl:if>

	</div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/>
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
                <!--<xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-subjects"/>
		<!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Zeitschriftenartikel-->

	
	 <!--Zeitschriftenartikel/Review-->
          <xsl:when test="dim:field[@element='type'] = 'article' or dim:field[@element='type'] = 'review' or dim:field[@element='tpye'] = 'digitalReproduction'">
		<div class="itemview-citation">
		<xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or 
dim:field[@element='contributor' and descendant::text()]">
                   <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                        <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C', 
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='author']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='creator']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='contributor']">
                        <xsl:for-each select="dim:field[@element='contributor']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" /><xsl:text>, </xsl:text>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
                        </xsl:if>
                         <xsl:text> </xsl:text>
                        <xsl:call-template name="itemSummaryView-DIM-date"/>
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
		<xsl:if test="dim:field[@element='relation'][@qualifier='journal']">
			<i><xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']/node()"/></i>
		</xsl:if>
		 <xsl:if test="dim:field[@element='relation'][@qualifier='journalalt']">
                        <i><xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='journalalt']/node()"/></i>
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





                </div>
        <div class="itemview-citation-small">
	<xsl:if test="dim:field[@element='type'] = 'review'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.dctypereview</i18n:text>
        </xsl:if>
        <xsl:if test="dim:field[@element='type'] = 'article'">
                <i18n:text>xmlui.dri2xhtml.METS-1.0.dctypearticle</i18n:text>
        </xsl:if>
        <xsl:if test="dim:field[@element='type'] = 'digitalReproduction'">
		<i18n:text>xmlui.dri2xhtml.METS-1.0.dctypedigital</i18n:text>
	</xsl:if>
	</div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/>
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
                <!--<xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-subjects"/>
		<!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Zeitschriftenartikel-->
			
<!--Konferenzen-->
          <xsl:when test="dim:field[@element='type'] = 'conferenceBoA' or dim:field[@element='type'] = 'conferenceCall' or dim:field[@element='type'] = 
'conferenceProg' or dim:field[@element='type'] = 'conferencePaper'">
		<!-- <b>dc.contributor.organiser, </b> <i>dc.title, </i> dc.relation.event. -->
		<div class="itemview-citation">
 
                        <xsl:if test="dim:field[@element='contributor'][@qualifier='organiser']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='organiser']">
				<a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', .)" /></xsl:attribute>
                                 <xsl:value-of select="./node()"/> <xsl:if test="count(following-sibling::dim:field[@element='contributor' and 
@qualifier='organiser']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                                </a>

                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="dim:field[@element='contributor'][@qualifier='organisertwo']">
                            <xsl:text>; </xsl:text><xsl:for-each select="dim:field[@element='contributor'][@qualifier='organisertwo']">
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
                            <xsl:text>; </xsl:text><xsl:for-each select="dim:field[@element='contributor'][@qualifier='organiserthree']">
				<a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', .)" /></xsl:attribute>
                                 <xsl:value-of select="./node()"/> <xsl:if test="count(following-sibling::dim:field[@element='contributor' and 
@qualifier='organiserthree']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                                </a>

                            </xsl:for-each>
                        </xsl:if>







		<xsl:choose>
                                <xsl:when test="count(dim:field[@element='title'][not(@qualifier)])">
                                <br/><i><xsl:value-of select="dim:field[@element='title'][not(@qualifier)]"/></i>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
				<xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != 
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <i><xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" /></i>
                                </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                </xsl:otherwise>
                                </xsl:choose>
		<!--<xsl:if test="dim:field[@element='relation'][@qualifier='event']">
			<xsl:text>. </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='event']/node()"/><xsl:text>. </xsl:text>
		</xsl:if>-->
		<xsl:if test="dim:field[@element='relation'][@qualifier='eventLocation']">
                        <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '?' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'"><xsl:text>. 
</xsl:text></xsl:if><br/><xsl:value-of select="dim:field[@element='relation'][@qualifier='eventLocation']/node()"/><xsl:text>, </xsl:text>
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
		<xsl:if test="dim:field[@element='contributor'][@qualifier='organizedBy']">
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
			<i><xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']/node()"/></i>
		
			 <xsl:if test="dim:field[@element='relation'][@qualifier='journalalt']"><i>
                        <xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='journalalt']/node()"/></i>
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



		                
                </div>
                <div class="itemview-citation-small"><xsl:if test="dim:field[@element='type'] = 
'conferenceBoA'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfboa</i18n:text></xsl:if><xsl:if test="dim:field[@element='type'] = 
'conferenceCall'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfcall</i18n:text></xsl:if><xsl:if test="dim:field[@element='type'] = 
'conferenceProg'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfprog</i18n:text></xsl:if><xsl:if test="dim:field[@element='type'] = 
'conferenceReport'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfreport</i18n:text></xsl:if><xsl:if test="dim:field[@element='type'] = 
'conferencePaper'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfpaper</i18n:text></xsl:if></div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/> <!-- <xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
		<xsl:call-template name="itemSummaryView-subjects"/>
		<!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/>
          </xsl:when>
<!--/Konferenzen-->

<!--Tagungsbericht-->
          <xsl:when test="dim:field[@element='type'] = 'conferenceReport'">
		<!-- <b>dc.contributor.organiser, </b> <i>dc.title, </i> dc.relation.event. -->
		<div class="itemview-citation">
 
		<xsl:choose>
                                   <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', .)" /></xsl:attribute>
                                 <xsl:value-of select="./node()"/> <xsl:if test="count(following-sibling::dim:field[@element='contributor' and 
@qualifier='author']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                                </a>
                                </xsl:for-each>
                        </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                   </xsl:choose>
		<xsl:if test="dim:field[@element='date' and @qualifier='issued' and descendant::text()]">
                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
                    <xsl:text> (</xsl:text><xsl:copy-of select="substring(./node(),1,10)"/><xsl:text>):</xsl:text>
                </xsl:for-each>
        </xsl:if>
		<xsl:choose>
                                <xsl:when test="count(dim:field[@element='title'][not(@qualifier)])">
                                <br/><i><xsl:value-of select="dim:field[@element='title'][not(@qualifier)]"/></i>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
				<xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != 
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <i><xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" /></i>
                                </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                </xsl:otherwise>
                                </xsl:choose>
		<!--<xsl:if test="dim:field[@element='relation'][@qualifier='event']">
			<xsl:text>. </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='event']/node()"/><xsl:text>. </xsl:text>
		</xsl:if>-->
		<xsl:if test="dim:field[@element='relation'][@qualifier='eventLocation']">
                        <xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '?' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'"><xsl:text>. 
</xsl:text></xsl:if><xsl:value-of select="dim:field[@element='relation'][@qualifier='eventLocation']/node()"/><xsl:text>, </xsl:text>
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
                                </xsl:for-each>
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
                        </xsl:for-each><xsl:text>. </xsl:text>
<xsl:if test="dim:field[@element='relation'][@qualifier='journal']">
			<i><xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']/node()"/></i>
		</xsl:if>
		 <xsl:if test="dim:field[@element='relation'][@qualifier='journalalt']">
                        <i><xsl:text>: </xsl:text><xsl:value-of select="dim:field[@element='relation'][@qualifier='journalalt']/node()"/></i>
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
</xsl:if>		                
                </div>
                <div class="itemview-citation-small"><xsl:if test="dim:field[@element='type'] = 
'conferenceBoA'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfboa</i18n:text></xsl:if><xsl:if test="dim:field[@element='type'] = 
'conferenceCall'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfcall</i18n:text></xsl:if><xsl:if test="dim:field[@element='type'] = 
'conferenceProg'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfprog</i18n:text></xsl:if><xsl:if test="dim:field[@element='type'] = 
'conferenceReport'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfreport</i18n:text></xsl:if><xsl:if test="dim:field[@element='type'] = 
'conferencePaper'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeconfpaper</i18n:text></xsl:if></div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/> <!-- <xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
		<xsl:call-template name="itemSummaryView-subjects"/>
		<!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/>
          </xsl:when>
<!--/Tagungsbericht-->

	
	<!--Call for Paper-->
          <xsl:when test="dim:field[@element='type'] = 'cfppublication'">
                
                <div class="itemview-citation">
                   <xsl:choose>
                                   <xsl:when test="dim:field[@element='contributor'][@qualifier='editor']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
                                <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C', 
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                 <xsl:value-of select="./node()"/>
								 <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='editor']) != 
0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                                </a><xsl:text>:</xsl:text>
                                </xsl:for-each>
                        </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-editor</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
                
				<xsl:choose>
                                <xsl:when test="count(dim:field[@element='title'][not(@qualifier)])">
                                <br/><xsl:value-of select="dim:field[@element='title'][not(@qualifier)]"/>
								<xsl:if test="not(contains(dim:field[@element='title'][1]/node(), 'Call for'))"><xsl:text> (Call for 
Papers)</xsl:text>
                                </xsl:if>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
				<xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != 
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <i><xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" /></i>
                                </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                </xsl:otherwise>
                                </xsl:choose>
				
				
				
                <xsl:if test="dim:field[@element='relation'][@qualifier='journal']">
                        <xsl:text>. </xsl:text><i><xsl:value-of select="dim:field[@element='relation'][@qualifier='journal']/node()"/><xsl:text> </xsl:text></i>
                </xsl:if>
				<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='volume']">
                       <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='volume']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='issue']">
                         <xsl:text>. </xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='issue']/node()"/><xsl:text>. </xsl:text>
                </xsl:if>
              
                </div>
                <div class="itemview-citation-small"><xsl:if test="dim:field[@element='type'] = 
'cfppublication'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypecfppublication</i18n:text></xsl:if></div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/> <!-- <xsl:call-template name="itemSummaryView-collections"/>-->
                <xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
		<xsl:call-template name="itemSummaryView-subjects"/>
                <!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
                <xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Call for Paper-->
	
				
	<!--Seminare-->
          <xsl:when test="dim:field[@element='type'] = 'courseDescription' or dim:field[@element='type'] = 'syllabus'">
		<!-- <b>dc.contributor.lecturer, </b> <i>dc.title, </i> dc.description.seminar, dc.description.location, dc.description.institution, 
dc.description.semester.-->
		<div class="itemview-citation">
                   <xsl:choose>
				 <xsl:when test="dim:field[@element='contributor'][@qualifier='lecturer']">
                                <xsl:for-each select="dim:field[@element='contributor'][@qualifier='lecturer']">
                                <a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C', 
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                 <xsl:value-of select="./node()"/><xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='lecturer']) 
!= 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                                </a>
                                </xsl:for-each>
                        </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-lecturer</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
		<xsl:choose>
                                <xsl:when test="count(dim:field[@element='title'][not(@qualifier)])">
                                <br/><i><xsl:value-of select="dim:field[@element='title'][not(@qualifier)]"/></i>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
				<xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != 
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <i><xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" /></i>
                                </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                </xsl:otherwise>
                </xsl:choose>
		<xsl:if test="dim:field[@element='description'][@qualifier='seminar']">
			<xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '?' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'"><xsl:text>. 
</xsl:text></xsl:if><xsl:value-of select="dim:field[@element='description'][@qualifier='seminar']/node()"/>
		</xsl:if>
		<xsl:if test="dim:field[@element='description'][@qualifier='location']">
                       <xsl:text>. </xsl:text> <xsl:value-of select="dim:field[@element='description'][@qualifier='location']/node()"/>
                </xsl:if>
		<xsl:if test="dim:field[@element='description'][@qualifier='institution']">
                         <xsl:text>, </xsl:text><xsl:value-of select="dim:field[@element='description'][@qualifier='institution']/node()"/>
                </xsl:if>
		<xsl:if test="dim:field[@element='description'][@qualifier='semester']">
                         <xsl:text>, </xsl:text><xsl:value-of select="dim:field[@element='description'][@qualifier='semester']/node()"/><xsl:text>. </xsl:text>
                </xsl:if>
                
                </div>
                <div class="itemview-citation-small"><xsl:if test="dim:field[@element='type'] = 
'courseDescription'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypecoursedesc</i18n:text></xsl:if><xsl:if test="dim:field[@element='type'] = 
'syllabus'"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypesyllabus</i18n:text></xsl:if></div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/> <!-- <xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
		<xsl:call-template name="itemSummaryView-subjects"/>
		<!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Seminare-->
	
	<!--Sammelband-->
	<!-- <b>dc.contributor.editor</b>, <i>dc.title</i>, dc.publishedIn: dc.publisher, date -->
          <xsl:when test="dim:field[@element='type'] = 'anthology'">
                <div class="itemview-citation">
                   <xsl:choose>
				   <xsl:when test="dim:field[@element='contributor'][@qualifier='editor']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
				<a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C', 
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                 <xsl:value-of select="./node()"/><xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='editor']) != 
0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                                </a>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-editor</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
			
			<xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) = 1">
                         <i18n:text>xmlui.dri2xhtml.METS-1.0.item-editorone</i18n:text>
                        </xsl:if>
                        <xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) &gt; 1">
                         <i18n:text>xmlui.dri2xhtml.METS-1.0.item-editormult</i18n:text>
                        </xsl:if>
			
                        <xsl:call-template name="itemSummaryView-DIM-date"/>
                                <xsl:choose>
                                <xsl:when test="count(dim:field[@element='title'][not(@qualifier)])">
                                <i><xsl:value-of select="dim:field[@element='title'][not(@qualifier)]"/></i>
                                <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
				<xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != 
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'">
                                <xsl:text>:</xsl:text>
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <i><xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']" /></i>
                                </xsl:if>
				<xsl:if test="substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != 
'?' and substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '!' and 
substring(dim:field[@element='title'][not(@qualifier)], string-length(dim:field[@element='title'][not(@qualifier)])) != '.'"><xsl:if 
test="not(dim:field[@element='title'][@qualifier='alternative'])"><xsl:text>. </xsl:text></xsl:if></xsl:if>
                                <xsl:if test="substring(dim:field[@element='title'][@qualifier='alternative'], 
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '?' and substring(dim:field[@element='title'][@qualifier='alternative'], 
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '!' and substring(dim:field[@element='title'][@qualifier='alternative'], 
string-length(dim:field[@element='title'][@qualifier='alternative'])) != '.'"><xsl:if test="dim:field[@element='title'][@qualifier='alternative']"><xsl:text>. 
</xsl:text></xsl:if>
                                </xsl:if>
				</xsl:when>
                                <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                </xsl:otherwise>
                                </xsl:choose>
                <xsl:call-template name="itemSummaryView-DIM-publishedIn"/>
		 <xsl:if test="dim:field[@element='publisher']">
                        <xsl:value-of select="dim:field[@element='publisher']/node()"/><xsl:text>. </xsl:text></xsl:if>
		<xsl:call-template name="itemSummaryView-DIM-ispartofseries"/></div>
		<div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeantho</i18n:text></div>
                <!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/> <!-- <xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
		<xsl:call-template name="itemSummaryView-subjects"/>
		<!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Sammelband-->
	<!--Sammelbandbeitrag-->
          <xsl:when test="dim:field[@element='type'] = 'anthologyArticle' or dim:field[@element='type'] = 'blogentry'">
                <div class="itemview-citation">
                <xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or 
dim:field[@element='contributor' and descendant::text()]">
                   <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
				<a>
                                <xsl:attribute name="href"><xsl:value-of select="concat('/browse?type=author&amp;value=', substring-before(., ','), '%2C', 
translate(substring-after(., ','), ' ', '+'))" /></xsl:attribute>
                                <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                                </a>
				 <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='author']) != 0">
                        <xsl:text>; </xsl:text>
                        </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                   </xsl:choose>
		</xsl:if>
		<xsl:text> </xsl:text><xsl:call-template name="itemSummaryView-DIM-date"/>
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
		<xsl:if test="dim:field[@element='relation'][@qualifier='ispartof']">
			<xsl:text> </xsl:text><i><xsl:value-of select="dim:field[@element='relation'][@qualifier='ispartof']/node()"/>
			
			<xsl:if test="dim:field[@element='relation'][@qualifier='ispartofalt']"><xsl:text>: </xsl:text></xsl:if>
			<xsl:value-of select="dim:field[@element='relation'][@qualifier='ispartofalt']/node()"/>
			</i>
		</xsl:if>
		<xsl:if test="dim:field[@element='description'][@qualifier='institution']">
                       <xsl:text>. </xsl:text><xsl:value-of select="dim:field[@element='description'][@qualifier='institution']/node()"/>
                </xsl:if>
		<xsl:if test="dim:field[@element='relation'][@qualifier='editor']">
                        
			<xsl:if test="count(dim:field[@element='relation'][@qualifier='editor']) = 1">
                         <xsl:text>. </xsl:text><i18n:text>xmlui.dri2xhtml.METS-1.0.editorone</i18n:text>
                        </xsl:if>
                        <xsl:if test="count(dim:field[@element='relation'][@qualifier='editor']) &gt; 1">
                         <xsl:text>. </xsl:text><i18n:text>xmlui.dri2xhtml.METS-1.0.editormult</i18n:text>
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
		 <xsl:if test="dim:field[@element='date'][@qualifier='blog']">
                        <xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='blog']/node(),9,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring(dim:field[@element='date'][@qualifier='blog']/node(),6,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring(dim:field[@element='date'][@qualifier='blog']/node(),1,4)"/><xsl:text>.</xsl:text>
                </xsl:if>
                 <xsl:call-template name="itemSummaryView-DIM-publishedIn"/><xsl:call-template name="itemSummaryView-DIM-publisher"/>
		 <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']">
                       <xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']/node()"/>
                </xsl:if>
                <xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']">
                         <xsl:text>&#150;</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']/node()"/><xsl:text>. 
</xsl:text>
                </xsl:if>
		<xsl:call-template name="itemSummaryView-DIM-ispartofseries"/>
		
                </div>
		<xsl:if test="dim:field[@element='type'] = 'anthologyArticle'">
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeanthoarticle</i18n:text></div>
		</xsl:if>
		<xsl:if test="dim:field[@element='type'] = 'blogentry'">
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.dctypeblogentry</i18n:text></div>
                </xsl:if>
		<!--<xsl:call-template name="itemSummaryView-DIM-typeVersion"/>
                <xsl:call-template name="itemSummaryView-DIM-language"/>
                <xsl:call-template name="itemSummaryView-DIM-relationIsPartOf"/>
                <xsl:call-template name="itemSummaryView-DIM-descriptionSponsor"/>-->
                <xsl:call-template name="itemSummaryView-DIM-URI"/>
                <xsl:call-template name="itemSummaryView-DIM-DOI"/>
		<xsl:call-template name="itemSummaryView-DIM-relDOI"/>
                <span class="spacer">&#160;</span>
                <table class="item-view"><tr><td><xsl:call-template name="itemSummaryView-DIM-thumbnail"/></td>
                <td><xsl:call-template name="itemSummaryView-DIM-file-section"/>
                <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
                </xsl:if></td></tr></table>
                <xsl:call-template name="itemSummaryView-DIM-abstract"/> <!-- <xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
		<xsl:call-template name="itemSummaryView-subjects"/>
		<!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/>
          </xsl:when>
                <!--/Sammelbandbeitrag-->
	  <xsl:otherwise>
		 <xsl:call-template name="itemSummaryView-DIM-title"/>
            <div class="row">
                <div class="col-sm-4">
                    <div class="row">
                        <div class="col-xs-6 col-sm-12">
                            <xsl:call-template name="itemSummaryView-DIM-thumbnail"/>
                        </div>
                        <div class="col-xs-6 col-sm-12">
                            <xsl:call-template name="itemSummaryView-DIM-file-section"/>
                        </div>
                    </div>
                    <xsl:call-template name="itemSummaryView-DIM-date"/>
                    <xsl:call-template name="itemSummaryView-DIM-authors"/>
                    <xsl:if test="$ds_item_view_toggle_url != ''">
                        <xsl:call-template name="itemSummaryView-show-full"/>
                    </xsl:if>
                </div>
                <div class="col-sm-8">
                    <xsl:call-template name="itemSummaryView-DIM-abstract"/>
			<xsl:call-template name="itemSummaryView-DIM-publisherNote"/>
                    <xsl:call-template name="itemSummaryView-DIM-URI"/>
                    <!--<xsl:call-template name="itemSummaryView-collections"/>-->
		<xsl:call-template name="itemSummaryView-subjects"/>
		<!-- <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.standard-license-text</i18n:text></div>
                <div class="itemview-citation-small"><i18n:text>xmlui.dri2xhtml.METS-1.0.link-standard-license</i18n:text></div>-->
		<xsl:call-template name="display-rights"/> </div>
            </div>
	  </xsl:otherwise>
	</xsl:choose>
	<!--Twitter-Share-Button-->
	<div data-services="[&quot;twitter&quot;]" class="shariff" id="socialmedia">
                        <ul class="share-buttons">
				<li><a>
                                        <xsl:attribute name="href"><xsl:value-of select="concat('http://twitter.com/intent/tweet?text=', //dim:field[@element='title' 
and not(@qualifier)], '&amp;url=', //dim:field[@element='identifier' and @qualifier='uri']) "/></xsl:attribute>
                                <!--<img src="{concat($theme-path,'images/twitter-16.png')}" title="Twitter"> </img>-->
                                </a></li>
                        </ul>
	</div>
        </div>
    </xsl:template>
    <xsl:template name="itemSummaryView-DIM-title">
        <xsl:choose>
            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                <h2 class="page-header first-page-header">
                    <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                </h2>
                <div class="simple-item-view-other">
                    <p class="lead">
                        <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                            <xsl:if test="not(position() = 1)">
                                <xsl:value-of select="./node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                    <xsl:text>; </xsl:text>
                                    <br/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </p>
                </div>
            </xsl:when>
            <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                <h2 class="page-header first-page-header">
                    <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                </h2>
            </xsl:when>
            <xsl:otherwise>
                <h2 class="page-header first-page-header">
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                </h2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="itemSummaryView-DIM-thumbnail">
        <div class="thumbnail">
            <xsl:choose>
                <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                    <xsl:variable name="src">
                        <xsl:choose>
                            <xsl:when 
test="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=../../mets:fileGrp[@USE='CONTENT']/mets:file[@GROUPID=../../mets:fileGrp[@USE='THUMBNAIL']/mets:file/@GROUPID][1]/@GROUPID]">
                                <xsl:value-of
                                        select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=../../mets:fileGrp[@USE='CONTENT']/mets:file[@GROUPID=../../mets:fileGrp[@USE='THUMBNAIL']/mets:file/@GROUPID][1]/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                        select="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
		<a>
		<xsl:attribute name="href">
		<xsl:value-of select="concat(substring-before($src,'.jpg'), '?sequence=1&amp;isAllowed=y')"/>
                </xsl:attribute>
			<img alt="Thumbnail">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$src"/>
                        </xsl:attribute>
                    </img>
		</a>
                </xsl:when>
                <xsl:otherwise>
                    <img alt="Thumbnail">
                        <xsl:attribute name="data-src">
                            <xsl:text>holder.js/100%x</xsl:text>
                            <xsl:value-of select="$thumbnail.maxheight"/>
                            <xsl:text>/text:No Thumbnail</xsl:text>
                        </xsl:attribute>
                    </img>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template name="itemSummaryView-DIM-abstract">
        <xsl:if test="dim:field[@element='description' and @qualifier='abstract']">
            <div class="simple-item-view-description item-page-field-wrapper table">
                <h5 class="visible-xs"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></h5>
                <div>
                    <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                            <div class="spacer">&#160;</div>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                        <div class="spacer">&#160;</div>
                    </xsl:if>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
<xsl:template name="itemSummaryView-DIM-publisherNote">
        <xsl:if test="dim:field[@element='description' and @qualifier='publisherNote']">
            <div class="simple-item-view-description item-page-field-wrapper table">
                <h5 class="visible-xs"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></h5>
                <div>
                    <xsl:for-each select="dim:field[@element='description' and @qualifier='publisherNote']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='publisherNote']) != 0">
                            <div class="spacer">&#160;</div>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="count(dim:field[@element='description' and @qualifier='publisherNote']) &gt; 1">
                        <div class="spacer">&#160;</div>
                    </xsl:if>
                    </div>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template name="itemSummaryView-DIM-authors">
        <xsl:if test="dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or 
dim:field[@element='contributor' and descendant::text()]">
            <div class="simple-item-view-authors item-page-field-wrapper table">
                <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text></h5>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='creator']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='contributor']">
                        <xsl:for-each select="dim:field[@element='contributor']">
                            <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template name="itemSummaryView-DIM-authors-entry">
        
            <xsl:if test="@authority">
                <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="node()"/>
        
    </xsl:template>
   
    <xsl:template name="itemSummaryView-DIM-URI">
       <xsl:if test="dim:field[@element='identifier' and @qualifier='uri' and descendant::text()]">
          <div class="simple-item-view-uri item-page-field-wrapper table">
                <span>
                    <xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
                        <xsl:if test="starts-with(./node(), 'http://resolver')">
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.citation-link</i18n:text><a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>
                        </xsl:if>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template name="itemSummaryView-DIM-relDOI">
       <xsl:if test="dim:field[@element='relation' and @qualifier='doi' and descendant::text()]">
                <div class="simple-item-view-uri item-page-field-wrapper table">
                <span>
                     <i18n:text>xmlui.dri2xhtml.METS-1.0.relationDOI</i18n:text>
                        <a>
                        <xsl:attribute name="href">
                                <xsl:copy-of select="concat('https://doi.org/', dim:field[@element='relation'][@qualifier='doi'][1]/node())"/>
                        </xsl:attribute>
                        <xsl:copy-of select="concat('https://doi.org/', dim:field[@element='relation'][@qualifier='doi'][1]/node())"/>
                        </a>
                </span>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template name="itemSummaryView-DIM-DOI">
       <xsl:if test="dim:field[@element='identifier' and @qualifier='doi' and descendant::text()]">
		<div class="simple-item-view-uri item-page-field-wrapper table">
                <span>
                     <xsl:text>DOI: </xsl:text>
			<a>
			<xsl:attribute name="href">
				<xsl:copy-of select="concat('https://doi.org/', dim:field[@element='identifier'][@qualifier='doi'][1]/node())"/>
                	</xsl:attribute>
			<xsl:copy-of select="concat('https://doi.org/', dim:field[@element='identifier'][@qualifier='doi'][1]/node())"/>
			</a>
		</span>
            </div>
        </xsl:if>
    </xsl:template> <!-- <xsl:template name="itemSummaryView-DIM-originalDOI">
       <xsl:if test="dim:field[@element='identifier' and @qualifier='doi' and descendant::text()]">
                <div class="simple-item-view-uri item-page-field-wrapper table">
                <span>
                    <xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
                        <xsl:if test="not(starts-with(./node(), '10.25356'))">
                                <xsl:text>Original-DOI: </xsl:text><xsl:copy-of select="./node()"/>
                        </xsl:if>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
    </xsl:template>-->
	
	<xsl:template name="itemSummaryView-DIM-publisher">
        	<xsl:if test="dim:field[@element='publisher']">
                	<xsl:for-each select="dim:field[@element='publisher']">
                        	<xsl:copy-of select="./node()"/><xsl:text>. </xsl:text>
                	</xsl:for-each>
        	</xsl:if>
	</xsl:template>
	 <xsl:template name="itemSummaryView-DIM-publishedIn">
                <xsl:if test="dim:field[@element='publishedIn']">
                        <xsl:for-each select="dim:field[@element='publishedIn']">
                               <xsl:copy-of select="./node()"/><xsl:text>: </xsl:text>
                        </xsl:for-each>
                </xsl:if>
        </xsl:template>
	 <xsl:template name="itemSummaryView-DIM-ispartofseries">
                <xsl:if test="dim:field[@element='relation' and @qualifier='ispartofseries']">
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
		<xsl:if test="not(dim:field[@element='relation' and @qualifier='ispartofseries']) and dim:field[@element='relation' and @qualifier='volume']">
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
        </xsl:template>
	<xsl:template name="itemSummaryView-DIM-editors">
                <xsl:if test="dim:field[@element='contributor' and @qualifier='editor']">
                        <xsl:for-each select="dim:field[@element='contributor' and @qualifier='editor']">
                                <xsl:copy-of select="./node()"/>
                        </xsl:for-each>
                </xsl:if>
        </xsl:template>
    <xsl:template name="itemSummaryView-DIM-date">
        <xsl:if test="dim:field[@element='date' and @qualifier='issued' and descendant::text()]">
                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
                    <xsl:text>(</xsl:text><xsl:copy-of select="substring(./node(),1,10)"/><xsl:text>):</xsl:text>
                        <br/>
                </xsl:for-each>
        </xsl:if>
    </xsl:template>
	
	<xsl:template name="itemSummaryView-DIM-date-default">
        <xsl:if test="dim:field[@element='date' and @qualifier='issued' and descendant::text()]">
                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
                    <xsl:copy-of select="substring(./node(),1,10)"/>
                    <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
                        <br/>
                    </xsl:if>
                </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="itemSummaryView-show-full">
        <div class="simple-item-view-show-full item-page-field-wrapper table">
            <h5>
                <i18n:text>xmlui.mirage2.itemSummaryView.MetaData</i18n:text>
            </h5>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
            </a>
        </div>
    </xsl:template>
    <xsl:template name="itemSummaryView-collections">
        <xsl:if test="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']">
            <div class="simple-item-view-collections item-page-field-wrapper table">
                <h5>
                    <i18n:text>xmlui.mirage2.itemSummaryView.Collections</i18n:text>
                </h5>
                <xsl:apply-templates select="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']/dri:reference"/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template name="itemSummaryView-subjects">
         <xsl:if test="dim:field[@element='subject' and @qualifier='field']">
            <div class="simple-item-view-collections item-page-field-wrapper table" style="margin-bottom: 1.5em;">
                <h5>
                        <i18n:text>xmlui.mirage2.itemSummaryView.Subjects</i18n:text>
                </h5>
                <xsl:for-each select="dim:field[@element='subject' and @qualifier='field']">
                        <a><xsl:attribute name="href"><xsl:value-of 
select="concat('https://thestacks.libaac.de/discover?filtertype=SubjectField&amp;filter_relational_operator=equals', '&amp;filter=', 
./node())"/></xsl:attribute><xsl:value-of select="./node()"/></a><br/>
                </xsl:for-each>
           </div>
        </xsl:if>
    </xsl:template>
    <xsl:template name="itemSummaryView-DIM-file-section">
        <xsl:choose>
            <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                <div class="item-page-field-wrapper table word-break">
                    <h5>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                    </h5>
                    <xsl:variable name="label-1">
                            <xsl:choose>
                                <xsl:when test="confman:getProperty('mirage2.item-view.bitstream.href.label.1')">
                                    <xsl:value-of select="confman:getProperty('mirage2.item-view.bitstream.href.label.1')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>label</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="label-2">
                            <xsl:choose>
                                <xsl:when test="confman:getProperty('mirage2.item-view.bitstream.href.label.2')">
                                    <xsl:value-of select="confman:getProperty('mirage2.item-view.bitstream.href.label.2')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>title</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                    </xsl:variable>
                    <xsl:for-each select="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                        <xsl:call-template name="itemSummaryView-DIM-file-section-entry">
                            <xsl:with-param name="href" select="mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                            <xsl:with-param name="mimetype" select="@MIMETYPE" />
                            <xsl:with-param name="label-1" select="$label-1" />
                            <xsl:with-param name="label-2" select="$label-2" />
                            <xsl:with-param name="title" select="mets:FLocat[@LOCTYPE='URL']/@xlink:title" />
                            <xsl:with-param name="label" select="mets:FLocat[@LOCTYPE='URL']/@xlink:label" />
                            <xsl:with-param name="size" select="@SIZE" />
                        </xsl:call-template>
                    </xsl:for-each>
                </div>


 <!--Metadaten-Export-->
                <div class="metadataexport"><h5><i18n:text>xmlui.metadata.export</i18n:text></h5>
                        <a><xsl:attribute name="href"><xsl:value-of select="concat('/endnote/handle/11858/', substring-after(dim:field[@element='identifier'][@qualifier='uri'], '11858/'))"/></xsl:attribute><xsl:text>Endnote</xsl:text></a><br/>
                        <a><xsl:attribute name="href"><xsl:value-of select="concat('/bibtex/handle/11858/', substring-after(dim:field[@element='identifier'][@qualifier='uri'], '11858/')) "/></xsl:attribute><xsl:text>BibTex</xsl:text></a><br/>
                        <a><xsl:attribute name="href"><xsl:value-of select="concat('/ris/handle/11858/', substring-after(dim:field[@element='identifier'][@qualifier='uri'], '11858/')) "/></xsl:attribute><xsl:text>RIS</xsl:text></a>
                </div>




            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="//mets:fileSec/mets:fileGrp[@USE='ORE']" mode="itemSummaryView-DIM" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="itemSummaryView-DIM-file-section-entry">
        <xsl:param name="href" />
        <xsl:param name="mimetype" />
        <xsl:param name="label-1" />
        <xsl:param name="label-2" />
        <xsl:param name="title" />
        <xsl:param name="label" />
        <xsl:param name="size" />
        <div>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$href"/>
                </xsl:attribute>
                <xsl:call-template name="getFileIcon">
                    <xsl:with-param name="mimetype">
                        <xsl:value-of select="substring-before($mimetype,'/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="substring-after($mimetype,'/')"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="contains($label-1, 'label') and string-length($label)!=0">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:when test="contains($label-1, 'title') and string-length($title)!=0">
                        <xsl:value-of select="$title"/>
                    </xsl:when>
                    <xsl:when test="contains($label-2, 'label') and string-length($label)!=0">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:when test="contains($label-2, 'title') and string-length($title)!=0">
                        <xsl:value-of select="$title"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before($mimetype,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains($mimetype,';')">
                                        <xsl:value-of select="substring-before(substring-after($mimetype,'/'),';')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after($mimetype,'/')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> (</xsl:text>
                <xsl:choose>
                    <xsl:when test="$size &lt; 1024">
                        <xsl:value-of select="$size"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="$size &lt; 1024 * 1024">
                        <xsl:value-of select="substring(string($size div 1024),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="$size &lt; 1024 * 1024 * 1024">
                        <xsl:value-of select="substring(string($size div (1024 * 1024)),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(string($size div (1024 * 1024 * 1024)),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>)</xsl:text>
            </a><br/> 
        </div>
    </xsl:template>
    <xsl:template match="dim:dim" mode="itemDetailView-DIM">
        <xsl:call-template name="itemSummaryView-DIM-title"/>
        <div class="ds-table-responsive">
            <table class="ds-includeSet-table detailtable table table-striped table-hover">
                <xsl:apply-templates mode="itemDetailView-DIM"/>
            </table>
        </div>
        <span class="Z3988">
            <xsl:attribute name="title">
                 <xsl:call-template name="renderCOinS"/>
            </xsl:attribute>
            &#xFEFF; <!-- non-breaking space to force separating the end tag -->
        </span>
        <xsl:copy-of select="$SFXLink" />
    </xsl:template>
    <xsl:template match="dim:field" mode="itemDetailView-DIM">
            <tr>
                <xsl:attribute name="class">
                    <xsl:text>ds-table-row </xsl:text>
                    <xsl:if test="(position() div 2 mod 2 = 0)">even </xsl:if>
                    <xsl:if test="(position() div 2 mod 2 = 1)">odd </xsl:if>
                </xsl:attribute>
                <td class="label-cell">
                    <xsl:value-of select="./@mdschema"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="./@element"/>
                    <xsl:if test="./@qualifier">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="./@qualifier"/>
                    </xsl:if>
                </td>
            <td class="word-break">
              <xsl:copy-of select="./node()"/>
            </td>
                <!--<td><xsl:value-of select="./@language"/></td>-->
            </tr>
    </xsl:template>
    <!-- don't render the item-view-toggle automatically in the summary view, only when it gets called -->
    <xsl:template match="dri:p[contains(@rend , 'item-view-toggle') and
        (preceding-sibling::dri:referenceSet[@type = 'summaryView'] or following-sibling::dri:referenceSet[@type = 'summaryView'])]">
    </xsl:template>
    <!-- don't render the head on the item view page -->
    <xsl:template match="dri:div[@n='item-view']/dri:head" priority="5">
    </xsl:template>
   <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
            <xsl:choose>
                <!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
                <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
                    <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!-- Otherwise, iterate over and display all of them -->
                <xsl:otherwise>
                    <xsl:apply-templates select="mets:file">
                     	<!--Do not sort any more bitstream order can be changed-->
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
   <xsl:template match="mets:fileGrp[@USE='LICENSE']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
            <xsl:apply-templates select="mets:file">
                        <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <div class="file-wrapper row">
            <div class="col-xs-6 col-sm-3">
                <div class="thumbnail">
                    <a class="image-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUPID=current()/@GROUPID]">
                                <img alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                    mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img alt="Thumbnail">
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
            </div>
            <div class="col-xs-6 col-sm-7">
                <dl class="file-metadata dl-horizontal">
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-name</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:attribute name="title">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                        </xsl:attribute>
                        <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:title, 30, 5)"/>
                    </dd>
                <!-- File size always comes in bytes and thus needs conversion -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:choose>
                            <xsl:when test="@SIZE &lt; 1024">
                                <xsl:value-of select="@SIZE"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </dd>
                <!-- Lookup File Type description in local messages.xml based on MIME Type.
         In the original DSpace, this would get resolved to an application via
         the Bitstream Registry, but we are constrained by the capabilities of METS
         and can't really pass that info through. -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains(@MIMETYPE,';')">
                                <xsl:value-of select="substring-before(substring-after(@MIMETYPE,'/'),';')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>
                    </dd>
                <!-- Display the contents of 'Description' only if bitstream contains a description -->
                <xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
                        <dt>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text>
                            <xsl:text>:</xsl:text>
                        </dt>
                        <dd class="word-break">
                            <xsl:attribute name="title">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                            </xsl:attribute>
                            <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:label, 30, 5)"/>
                        </dd>
                </xsl:if>
                </dl>
            </div>
            <div class="file-link col-xs-6 col-xs-offset-6 col-sm-2 col-sm-offset-0">
                <xsl:choose>
                    <xsl:when test="@ADMID">
                        <xsl:call-template name="display-rights"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="view-open"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div> </xsl:template>
    <xsl:template name="view-open">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
            </xsl:attribute>
            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
        </a>
    </xsl:template>
    <xsl:template name="display-rights">
        <!--<xsl:variable name="file_id" select="jstring:replaceAll(jstring:replaceAll(string(@ADMID), '_METSRIGHTS', ''), 'rightsMD_', '')"/>
        <xsl:variable name="rights_declaration" select="../../../mets:amdSec/mets:rightsMD[@ID = concat('rightsMD_', $file_id, 
'_METSRIGHTS')]/mets:mdWrap/mets:xmlData/rights:RightsDeclarationMD"/>
        <xsl:variable name="rights_context" select="$rights_declaration/rights:Context"/>
        <xsl:variable name="users">
            <xsl:for-each select="$rights_declaration/*">
                <xsl:value-of select="rights:UserName"/>
                <xsl:choose>
                    <xsl:when test="rights:UserName/@USERTYPE = 'GROUP'">
                       <xsl:text> (group)</xsl:text>
                    </xsl:when>
                    <xsl:when test="rights:UserName/@USERTYPE = 'INDIVIDUAL'">
                       <xsl:text> (individual)</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not ($rights_context/@CONTEXTCLASS = 'GENERAL PUBLIC') and ($rights_context/rights:Permissions/@DISPLAY = 'true')">
                <a href="{mets:FLocat[@LOCTYPE='URL']/@xlink:href}">
                    <img width="64" height="64" src="{concat($theme-path,'/images/Crystal_Clear_action_lock3_64px.png')}" title="Read access available for 
{$users}"/>-->
                    <!-- icon source: http://commons.wikimedia.org/wiki/File:Crystal_Clear_action_lock3.png -->
                <!--</a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="view-open"/>
            </xsl:otherwise>
        </xsl:choose>-->

                <xsl:choose>
                        <xsl:when test="dim:field[@element='rights'] = 'L::The Stacks License'">
                                <a href="/rights"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-thestacks-license</i18n:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC 1.0'">
							<img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 1.0" style="float:left;margin-right:10px;"/>
                                <a href="https://creativecommons.org/licenses/by-nc/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC 2.0'">
									<img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 2.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC 2.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 2.5" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-NC 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 3.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc/3.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc.png" alt="Attribution-NonCommercial 4.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC 4.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'L::CC BY 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 1.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by/1.0/" style="font-size:20px">
                                <xsl:text>CC BY 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 2.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by/2.0/" style="font-size:20px">
                                <xsl:text>CC BY 2.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'L::CC BY 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 2.5" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by/2.5/" style="font-size:20px">
                                <xsl:text>CC BY 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 3.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by/3.0/" style="font-size:20px">
                                <xsl:text>CC BY 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by.png" alt="Attribution 4.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by/4.0/" style="font-size:20px">
                                <xsl:text>CC BY 4.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-SA 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 1.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-sa/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-SA 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-SA 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 2.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-sa/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-SA 2.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-SA 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 2.5" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-sa/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-SA 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-SA 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 3.0" style="float:left;margin-right:10px;"/>
                                <a href="https://creativecommons.org/licenses/by-sa/3.0/" style="font-size:20px">
                                <xsl:text> CC BY-SA 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-SA 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-sa.png" alt="Attribution-ShareAlike 4.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-sa/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-SA 4.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-ND 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 1.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nd/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-ND 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-ND 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 2.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nd/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-ND 2.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-ND 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 2.5" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nd/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-ND 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-ND 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 3.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nd/3.0/" style="font-size:20px">
                                <xsl:text>CC BY-ND 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-ND 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nd.png" alt="Attribution-NoDerivs 4.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nd/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-ND 4.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-ND 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
1.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-nd/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-ND 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
2.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-nd/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 2.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-ND 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
2.5" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-nd/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-ND 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
3.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-nd/3.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-ND 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-nd.png" alt="Attribution-NonCommercial-NoDerivs
4.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-nd/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-ND 4.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-SA 1.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
1.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-sa/1.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 1.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-SA 2.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
2.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-sa/2.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 2.0</xsl:text>
                                </a>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-SA 2.5'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
2.5" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-sa/2.5/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 2.5</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-SA 3.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
3.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-sa/3.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 3.0</xsl:text>
                                </a>
                        </xsl:when>
                         <xsl:when test="dim:field[@element='rights'] = 'L::CC BY-NC-SA 4.0'">
                                <img class="img-responsive" src="/themes/Mirage2/images/creativecommons/cc-by-nc-sa.png" alt="Attribution-NonCommercial-ShareAlike
4.0" style="float:left;margin-right:10px;"/>
								<a href="https://creativecommons.org/licenses/by-nc-sa/4.0/" style="font-size:20px">
                                <xsl:text>CC BY-NC-SA 4.0</xsl:text>
                                </a>
                        </xsl:when>
                </xsl:choose>


    </xsl:template>
    <xsl:template name="getFileIcon">
        <xsl:param name="mimetype"/>
            <i aria-hidden="true">
                <xsl:attribute name="class">
                <xsl:text>glyphicon </xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(mets:FLocat[@LOCTYPE='URL']/@xlink:href,'isAllowed=n')">
                        <xsl:text> glyphicon-lock</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> glyphicon-file</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
            </i>
        <xsl:text> </xsl:text>
    </xsl:template>
    <!-- Generate the license information from the file section -->
    <!--<xsl:template match="mets:fileGrp[@USE='CC-LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license_text']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_cc</i18n:text></a></li>
    </xsl:template>-->
    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license.txt']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_original_license</i18n:text></a></li>
    </xsl:template>
    <!--
    File Type Mapping template
    This maps format MIME Types to human friendly File Type descriptions.
    Essentially, it looks for a corresponding 'key' in your messages.xml of this
    format: xmlui.dri2xhtml.mimetype.{MIME Type}
    (e.g.) <message key="xmlui.dri2xhtml.mimetype.application/pdf">PDF</message>
    If a key is found, the translated value is displayed as the File Type (e.g. PDF)
    If a key is NOT found, the MIME Type is displayed by default (e.g. application/pdf)
    -->
    <xsl:template name="getFileTypeDesc">
        <xsl:param name="mimetype"/>
        <!--Build full key name for MIME type (format: xmlui.dri2xhtml.mimetype.{MIME type})-->
        <xsl:variable name="mimetype-key">xmlui.dri2xhtml.mimetype.<xsl:value-of select='$mimetype'/></xsl:variable>
        <!--Lookup the MIME Type's key in messages.xml language file.  If not found, just display MIME Type-->
        <i18n:text i18n:key="{$mimetype-key}"><xsl:value-of select="$mimetype"/></i18n:text>
    </xsl:template> </xsl:stylesheet>
