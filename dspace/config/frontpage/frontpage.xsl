<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:mets="http://www.loc.gov/METS/"
  xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
  xmlns:java="http://xml.apache.org/xalan/java"
  xmlns:confman="org.dspace.core.ConfigurationManager"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions">

    <!-- <xsl:message terminate="no">here is some message for stderr, e.g. <xsl:value-of select='text()' /> </xsl:message> -->
    <xsl:output indent="yes" method="xml" omit-xml-declaration="yes" encoding="UTF-8" />

    <xsl:variable name="workingDirectory" select="confman:getProperty('frontpage.config.directory')" />
    <xsl:variable name="genderopen-yellow" select="'#ffaa00'" />
    <xsl:variable name="genderopen-blue" select="'#455a64'" />
    <xsl:variable name="aacborder" select="'#c17e19'" />
    <xsl:variable name="urnprefix" select="'https://nbn-resolving.de/'" />
    <xsl:variable name="font-style" select="'Aller'" />

    <xsl:template match="/">
        <xsl:apply-templates select="mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
    </xsl:template>


    <xsl:template match="dim:dim">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">


            <fo:layout-master-set>
                <fo:simple-page-master master-name="DIN-A4" page-height="29.7cm" page-width="21cm" margin-left="2.1cm" margin-right="2.2cm">
                    <fo:region-body/>
                    <fo:region-before region-name="header" extent="0cm"/>
                    <fo:region-after region-name="footer" extent="20mm"/>
                    <fo:region-start region-name="left" extent="0cm"/>
                    <fo:region-end region-name="right" extent="0cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="DIN-A4">

                <!-- body -->
                <fo:flow flow-name="xsl-region-body" font-family="{$font-style}" font-size="9pt">
                    <!-- insert logo and link -->
                    <xsl:call-template name="header"/>

                    <!-- insert main metadata block -->
                    <xsl:call-template name="metadataBlock">
                        <xsl:with-param name="dimNode" select="."/>
                    </xsl:call-template>

                    <!-- insert publishernote block -->
                    <xsl:call-template name="publishernotesBlock">
                        <xsl:with-param name="dimNode" select="."/>
                    </xsl:call-template>

                    <!-- insert pi block -->
                    <xsl:call-template name="piBlock">
                        <xsl:with-param name="dimNode" select="."/>
                    </xsl:call-template>

                    <!-- insert license terms -->
                    <xsl:call-template name="licenseBlock">
                        <xsl:with-param name="dimNode" select="."/>
                    </xsl:call-template>

                    <!-- insert footer -->
                    <xsl:call-template name="footer"/>
                </fo:flow>

            </fo:page-sequence>


        </fo:root>
    </xsl:template>


    <xsl:template name="header">
        <fo:block-container position="absolute" top="19mm">
            <fo:block>
                <fo:basic-link external-destination="url('https://thestacks.libaac.de/')">
                <fo:external-graphic src="url('{$workingDirectory}/img/stacks_logo.jpg')" content-height="scale-to-fit" height="32mm" />
                </fo:basic-link>
            </fo:block>
        </fo:block-container>

        <fo:block-container width="100%" padding-before="40mm">
            <fo:block font-size="14pt" font-weight="bold" color="{$genderopen-blue}">
                    <fo:basic-link external-destination="url('https://thestacks.libaac.de/')">
                    </fo:basic-link>
            </fo:block>
        </fo:block-container>
    </xsl:template>


    <xsl:template name="footer">
        <fo:block-container position="absolute" top="250mm">
            <fo:block>
                <fo:basic-link external-destination="url('https://sub.uni-goettingen.de')">
                <fo:external-graphic src="url('{$workingDirectory}/img/SUB-logo.svg')" content-height="scale-to-fit" height="12mm" />
                </fo:basic-link>
            </fo:block>
        </fo:block-container>

        <fo:block-container position="absolute" top="245mm" left="50mm">
            <fo:block>
                <fo:basic-link external-destination="url('https://dfg.de')">
                <fo:external-graphic src="url('{$workingDirectory}/img/dfg-logo.jpg')" content-height="scale-to-fit" height="20mm" />
                </fo:basic-link>
            </fo:block>
        </fo:block-container>

        <fo:block-container position="absolute" top="237mm" left="127mm">
            <fo:block>
                <fo:basic-link external-destination="url('https://libaac.de')">
                <fo:external-graphic src="url('{$workingDirectory}/img/fid_footer.svg')" content-height="scale-to-fit" height="40mm" />
                </fo:basic-link>
            </fo:block>
        </fo:block-container>

<!--        <fo:block-container position="absolute" top="253mm" left="130mm">
            <fo:block>
                <fo:external-graphic src="url('{$workingDirectory}/img/tuberlin.svg')" content-height="scale-to-fit" height="15mm" />
            </fo:block>
        </fo:block-container>

        <fo:block-container position="absolute" top="300mm">
            <fo:block font-size="14pt" font-weight="bold" color="{$genderopen-blue}">
                <fo:basic-link external-destination="url('https://thestacks.libaac.de')">
                    <xsl:text>thestacks.libaac.de</xsl:text>
                </fo:basic-link>
            </fo:block>
        </fo:block-container>-->
    </xsl:template>


    <xsl:template name="metadataBlock">
        <xsl:param name="dimNode"/>

        <!--Insert top rounded corners-->
<!--        <fo:block-container position="relative" padding-top="20mm" >
            <fo:block line-height="0.5mm">
                 <fo:instream-foreign-object>
                     <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="5.5mm"  width="473.695px">
                         <rect x="0" y="0" rx="5mm" ry="5mm" width="100%" height="10mm" style="border:1px;border-color:#c17e19;"/>
                     </svg>
                 </fo:instream-foreign-object>
             </fo:block>
        </fo:block-container>-->

        <fo:block-container padding-top="20mm">
        <fo:block background-color="white" border-width="0.5mm" border-color="{$aacborder}" border-style="solid" fox:border-radius="5mm" padding-top="5mm" padding-bottom="5mm">
            <xsl:call-template name="displayMetadata">
                <xsl:with-param name="dimNode" select="$dimNode"/>
            </xsl:call-template>
        </fo:block>
        </fo:block-container>

        <!-- Insert bottom rounded corners -->
        <!--<fo:block line-height="0" padding-before="4px" >
            <fo:instream-foreign-object>
                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="5mm" width="473.695px">
                    <path id="rect6" d="m 473.695,-0.15494634 c 0,9.81496004 -7.90157,17.71653534 -17.71653,17.71653534 l -438.2,0 c -9.8149612,0 -17.7165361,-7.9015753 -17.7165361,-17.71653534 z" style="fill:{$genderopen-yellow};" />
                </svg>
            </fo:instream-foreign-object>
        </fo:block>-->
    </xsl:template>

    <xsl:template name="displayMetadata">
        <xsl:param name="dimNode"/>

        <xsl:variable name="dcContributorAuthor" select="$dimNode/dim:field[@mdschema='dc' and @element='contributor' and @qualifier='author']" />
        <xsl:variable name="dcContributorEditor" select="$dimNode/dim:field[@mdschema='dc' and @element='contributor' and @qualifier='editor']" />
        <xsl:variable name="dcDateIssued" select="$dimNode/dim:field[@mdschema='dc' and @element='date' and @qualifier='issued']" />
        <xsl:variable name="dcIdentifierDoi" select="$dimNode/dim:field[@mdschema='dc' and @element='identifier' and @qualifier='doi']" />
        <xsl:variable name="doiUrlString">
            <xsl:call-template name="getDoiUrl">
                <xsl:with-param name="rawDoi" select="$dcIdentifierDoi" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dcUri" select="$dimNode/dim:field[@mdschema='dc' and @element='identifier' and  @qualifier='uri']" />
        <xsl:variable name="dcTitle" select="$dimNode/dim:field[@mdschema='dc' and @element='title' and not(@qualifier)]" />
        <xsl:variable name="dcTitleSubtitle" select="$dimNode/dim:field[@mdschema='dc' and @element='title' and @qualifier='alternative']" />
        <xsl:variable name="dcType" select="$dimNode/dim:field[@mdschema='dc' and @element='type' and not(@qualifier)]" />
        <xsl:variable name="dcTypeVersion" select="$dimNode/dim:field[@mdschema='dc' and @element='type' and @qualifier='version']" />
        <xsl:variable name="dcRights" select="$dimNode/dim:field[@mdschema='dc' and @element='rights' and not(@qualifier)]" />

        <xsl:variable name="dcRelationJournal" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='journal']" />
        <xsl:variable name="dcBiblioVolume" select="$dimNode/dim:field[@mdschema='dc' and @element='bibliographicCitation' and @qualifier='volume']" />
        <xsl:variable name="dcBiblioIssue" select="$dimNode/dim:field[@mdschema='dc' and @element='bibliographicCitation' and @qualifier='issue']" />
        <xsl:variable name="dcBiblioFirst" select="$dimNode/dim:field[@mdschema='dc' and @element='bibliographicCitation' and @qualifier='firstPage']" />
        <xsl:variable name="dcBiblioLast" select="$dimNode/dim:field[@mdschema='dc' and @element='bibliographicCitation' and @qualifier='lastPage']" />
        <xsl:variable name="dcTitleSpecial" select="$dimNode/dim:field[@mdschema='dc' and @element='title' and @qualifier='specialissue']" />
        <xsl:variable name="dcBiblioArticle" select="$dimNode/dim:field[@mdschema='dc' and @element='bibliographicCitation' and @qualifier='article']" />

        <xsl:variable name="dcRelationIspartofseries" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='ispartofseries']" />
        <xsl:variable name="dcPublishedIn" select="$dimNode/dim:field[@mdschema='dc' and @element='publishedIn' and not(@qualifier)]" />
        <xsl:variable name="dcPublisher" select="$dimNode/dim:field[@mdschema='dc' and @element='publisher' and not(@qualifier)]" />
        <xsl:variable name="dcRelationIspartof" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='ispartof']" />
        <xsl:variable name="dcRelationIspartofalt" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='ispartofalt']" />
        <xsl:variable name="dcRelationVolume" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='volume']" />
        <xsl:variable name="dcDescriptionInstitution" select="$dimNode/dim:field[@mdschema='dc' and @element='description' and @qualifier='institution']" />

        <xsl:variable name="dcRelationEditor" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='editor']" />
		
		<xsl:variable name="dcContributorOrganiser" select="$dimNode/dim:field[@mdschema='dc' and @element='contributor' and @qualifier='organiser']" />
		<xsl:variable name="dcContributorOrganisertwo" select="$dimNode/dim:field[@mdschema='dc' and @element='contributor' and @qualifier='organisertwo']" />
		<xsl:variable name="dcContributorOrganiserthree" select="$dimNode/dim:field[@mdschema='dc' and @element='contributor' and @qualifier='organiserthree']" />
		<xsl:variable name="dcRelationEventlocation" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='eventLocation']" />
		<xsl:variable name="dcRelationEventstart" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='eventStart']" />
		<xsl:variable name="dcRelationEventend" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='eventEnd']" />
		<xsl:variable name="dcContributorOrganizedby" select="$dimNode/dim:field[@mdschema='dc' and @element='contributor' and @qualifier='organizedBy']" />
		
		<xsl:variable name="dcContributorLecturer" select="$dimNode/dim:field[@mdschema='dc' and @element='contributor' and @qualifier='lecturer']" />
		<xsl:variable name="dcDescriptionSeminar" select="$dimNode/dim:field[@mdschema='dc' and @element='description' and @qualifier='seminar']" />
		<xsl:variable name="dcDescriptionLocation" select="$dimNode/dim:field[@mdschema='dc' and @element='description' and @qualifier='location']" />
		<xsl:variable name="dcDescriptionSemester" select="$dimNode/dim:field[@mdschema='dc' and @element='description' and @qualifier='semester']" />

	<xsl:variable name="dcRelationUniversity" select="$dimNode/dim:field[@mdschema='dc' and @element='relation' and @qualifier='university']" />
        <xsl:variable name="dcDateSubmitted" select="$dimNode/dim:field[@mdschema='dc' and @element='date' and @qualifier='submitted']" />

         <xsl:if test="$dcContributorAuthor != ''">
            <fo:block font-size="13pt" start-indent="5mm" end-indent="5mm">
                <xsl:call-template name="join-elements">
                    <xsl:with-param name="elements" select="$dcContributorAuthor" />
                    <xsl:with-param name="delimiter" select="'; '" />
                </xsl:call-template>
                 <xsl:text> (</xsl:text>
                <xsl:value-of select="$dcDateIssued" /><xsl:text>):</xsl:text>
            </fo:block>
        </xsl:if>

        <xsl:if test="$dcContributorEditor != '' and $dcType='anthology'">
            <fo:block font-size="13pt" start-indent="5mm" end-indent="5mm">
                <xsl:call-template name="join-elements">
                    <xsl:with-param name="elements" select="$dcContributorEditor" />
                    <xsl:with-param name="delimiter" select="'; '" />
                </xsl:call-template>
<xsl:if test="count($dimNode/dim:field[@element='contributor'][@qualifier='editor']) = 1">
                         <xsl:text> (Ed.) / </xsl:text>
                        </xsl:if>
                        <xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) &gt; 1">
                         <xsl:text> (Eds.) ( </xsl:text>
                        </xsl:if>
                <xsl:value-of select="$dcDateIssued" /> <xsl:text>):</xsl:text>
            </fo:block>
        </xsl:if>

	<xsl:if test="$dcContributorLecturer != ''">
            <fo:block font-size="13pt" start-indent="5mm" end-indent="5mm">
                <xsl:call-template name="join-elements">
                    <xsl:with-param name="elements" select="$dcContributorLecturer" />
                    <xsl:with-param name="delimiter" select="'; '" />
                </xsl:call-template>
                 <xsl:text> (</xsl:text>
                <xsl:value-of select="$dcDateIssued" /><xsl:text>):</xsl:text>
            </fo:block>
        </xsl:if>

		
		<xsl:if test="$dcContributorOrganiser != '' and $dcType != 'lecture' and $dcType != 'conferenceReport'">
            <fo:block font-size="13pt" start-indent="5mm" end-indent="5mm">
                <xsl:call-template name="join-elements">
                    <xsl:with-param name="elements" select="$dcContributorOrganiser" />
                    <xsl:with-param name="delimiter" select="'; '" />
                </xsl:call-template>
				<xsl:if test="$dcContributorOrganisertwo != ''">
				<xsl:text>, </xsl:text><xsl:value-of select="$dcContributorOrganisertwo" />
				</xsl:if>
				<xsl:if test="$dcContributorOrganiserthree != ''">
				<xsl:text>, </xsl:text><xsl:value-of select="$dcContributorOrganiserthree" />
				</xsl:if>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="$dcDateIssued" /> <xsl:text>):</xsl:text>
            </fo:block>
        </xsl:if>


<!-- #### article, review #### -->
        <xsl:if test="$dcType = 'article' or $dcType = 'review'">

        <xsl:if test="$dcTitle != ''">
           <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <xsl:text>&quot;</xsl:text><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
                <xsl:text>.&quot; </xsl:text>
<!--            <xsl:text>&quot;</xsl:text><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                                        <xsl:if test="substring($dcTitle, string-length($dcTitle)) != '?' and substring($dcTitle, string-length($dcTitle)) != '!' and substring($dcTitle, string-length($dcTitle)) != '.'">
                                                <xsl:text>: </xsl:text>
                                        </xsl:if>
                                        <xsl:value-of select="$dcTitleSubtitle"/>
                                        <xsl:if test="substring($dcSubtitle, string-length($dcSubtitle)) != '?' and substring($dcSubtitle, string-length($dcSubtitle)) != '!' and substring($dcSubtitle, string-length($dcSubtitle)) != '.'">
                                                <xsl:text>.&quot; </xsl:text>
                                        </xsl:if>
                                        <xsl:if test="substring($dcSubtitle, string-length($dcSubtitle)) = '?' or substring($dcSubtitle, string-length($dcSubtitle)) = '!' or substring($dcSubtitle, string-length($dcSubtitle)) = '.'">
                                                <xsl:text>&quot; </xsl:text>
                                        </xsl:if>
                </xsl:if>
                                <xsl:if test="substring($dcTitle, string-length($dcTitle)) != '?' and substring($dcTitle, string-length($dcTitle)) != '!' and substring($dcTitle, string-length($dcTitle)) != '.'">
                                                <xsl:text>.&quot;</xsl:text>
                                </xsl:if>
                                <xsl:if test="substring($dcTitle, string-length($dcTitle)) = '?' or substring($dcTitle, string-length($dcTitle)) = '!' or substring($dcTitle, string-length($dcTitle)) = '.'">
                                                <xsl:text>&quot;</xsl:text>
                                </xsl:if>-->
                <xsl:if test="$dcTitleSpecial != ''">
                        <xsl:value-of select="$dcTitleSpecial"/>
                        <xsl:text>.</xsl:text>
                         <xsl:if test="$dcContributorEditor != ''">
<xsl:if test="count($dimNode/dim:field[@element='contributor'][@qualifier='editor']) = 1">
                         <xsl:text> Ed. </xsl:text>
                        </xsl:if>
                        <xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) &gt; 1">
                         <xsl:text> Eds. </xsl:text>
                        </xsl:if>
                                <xsl:call-template name="join-elements">
                                <xsl:with-param name="elements" select="$dcContributorEditor" />
                                <xsl:with-param name="delimiter" select="'; '" />
                                </xsl:call-template>
                                <xsl:text>.</xsl:text>
                        </xsl:if>
                        <xsl:text> Special issue of </xsl:text>
                </xsl:if>

                <xsl:if test="$dcRelationJournal != ''">
                    <fo:inline font-style="italic">
                        <xsl:value-of select="$dcRelationJournal"/>
                        <xsl:if test="string-length($dcBiblioVolume) = 0 and string-length($dcBiblioIssue) = 0 and string-length($dcBiblioArticle) = 0">
                        <xsl:text>.</xsl:text>
                        </xsl:if>
                    </fo:inline>
                </xsl:if>

                <xsl:if test="$dcBiblioVolume != ''">
                <xsl:text> </xsl:text><xsl:value-of select="$dcBiblioVolume"/>
                        <xsl:if test="string-length($dcBiblioIssue) != 0">
                        <xsl:text>. </xsl:text>
                        </xsl:if>
                </xsl:if>

                <xsl:if test="$dcBiblioIssue != ''">
                         <xsl:if test="string-length($dcBiblioVolume) = 0">
                                <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="$dcBiblioIssue"/>
                         <xsl:if test="string-length($dcBiblioFirst) = 0 and string-length($dcBiblioArticle) = 0">
                                <xsl:text>.</xsl:text>
                        </xsl:if>
                </xsl:if>

                <xsl:if test="$dcBiblioFirst != ''">
                <xsl:text>: </xsl:text><xsl:value-of select="$dcBiblioFirst"/>
                </xsl:if>
                <xsl:if test="$dcBiblioLast != ''">
                <xsl:text> - </xsl:text><xsl:value-of select="$dcBiblioLast"/><xsl:text>.</xsl:text>
                </xsl:if>
                 <xsl:if test="$dcBiblioArticle != ''">
                <xsl:text>: </xsl:text><xsl:value-of select="$dcBiblioArticle"/>
                </xsl:if>

            </fo:block>
        </xsl:if>

        </xsl:if>

<!-- #### monograph, anthology #### -->
        <xsl:if test="$dcType = 'monograph' or $dcType = 'anthology'">

        <xsl:if test="$dcTitle != ''">
           <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <fo:inline font-style="italic"><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
                                </fo:inline>
                <xsl:text>. </xsl:text>

                                <xsl:if test="$dcPublishedIn != ''">
                        <xsl:value-of select="$dcPublishedIn"/>
                        <xsl:text>: </xsl:text>
                </xsl:if>

                                <xsl:if test="$dcPublisher != ''">
                        <xsl:value-of select="$dcPublisher"/>
                        <xsl:text>. </xsl:text>
                </xsl:if>

                <xsl:if test="$dcRelationIspartofseries != ''">
                        <xsl:if test="contains($dcRelationIspartofseries, ';')">
                                <xsl:value-of select="substring-before($dcRelationIspartofseries, ';')"/><xsl:text> </xsl:text>
                                <xsl:value-of select="substring-after($dcRelationIspartofseries, '; ')"/>
                        </xsl:if>
                        <xsl:if test="not(contains($dcRelationIspartofseries, ';'))">
                                <xsl:value-of select="$dcRelationIspartofseries"/>
                        </xsl:if>
                        <xsl:text>.</xsl:text>
                </xsl:if>


            </fo:block>
        </xsl:if>
         </xsl:if>

<!-- #### anthologyArticle, blogentry #### -->
                <xsl:if test="$dcType = 'anthologyArticle' or $dcType = 'blogentry'">

        <xsl:if test="$dcTitle != ''">
           <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <xsl:text>&quot;</xsl:text><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
                                <xsl:text>.&quot; </xsl:text>
                <xsl:if test="$dcRelationIspartof != ''">
                        <xsl:if test="contains($dcRelationIspartof, ';')">
                                        <fo:inline font-style="italic">
                                                <xsl:value-of select="substring-before($dcRelationIspartof, ';')"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="substring-after($dcRelationIspartof, '; ')"/>
                                        </fo:inline>
                        </xsl:if>
                        <xsl:if test="not(contains($dcRelationIspartof, ';'))">
                                        <fo:inline font-style="italic">
                                                <xsl:value-of select="$dcRelationIspartof"/>
                                        </fo:inline>
                        </xsl:if>
                        <xsl:if test="$dcRelationIspartofalt != ''">
                                        <fo:inline font-style="italic">
                                                <xsl:text>: </xsl:text><xsl:value-of select="$dcRelationIspartofalt"/>
                                        </fo:inline>
                        </xsl:if>
                                                <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:if test="$dcDescriptionInstitution">
                      <xsl:value-of select="$dcDescriptionInstitution"/><xsl:text>. </xsl:text>
                </xsl:if>
                        <xsl:if test="$dcContributorEditor != ''">
<xsl:if test="count($dimNode/dim:field[@element='contributor'][@qualifier='editor']) = 1">
                         <xsl:text> Ed. </xsl:text>
                        </xsl:if>
                        <xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) &gt; 1">
                         <xsl:text> Eds. </xsl:text>
                        </xsl:if>
                                <xsl:call-template name="join-elements">
                                <xsl:with-param name="elements" select="$dcContributorEditor" />
                                <xsl:with-param name="delimiter" select="'; '" />
                                </xsl:call-template>
                                <xsl:text>. </xsl:text>
                        </xsl:if>
                        <xsl:if test="$dcRelationEditor != ''">
<xsl:if test="count($dimNode/dim:field[@element='relation'][@qualifier='editor']) = 1">
                         <xsl:text> Ed. </xsl:text>
                        </xsl:if>
                        <xsl:if test="count(dim:field[@element='relation'][@qualifier='editor']) &gt; 1">
                         <xsl:text> Eds. </xsl:text>
                        </xsl:if>
                                <xsl:call-template name="join-elements">
                                <xsl:with-param name="elements" select="$dcRelationEditor" />
                                <xsl:with-param name="delimiter" select="'; '" />
                                </xsl:call-template>
                                <xsl:text>. </xsl:text>
                        </xsl:if>
                        <xsl:if test="$dcPublishedIn != ''">
                        <xsl:value-of select="$dcPublishedIn"/>
                        <xsl:text>: </xsl:text>
                </xsl:if>

                                <xsl:if test="$dcPublisher != ''">
                        <xsl:value-of select="$dcPublisher"/>
                        <xsl:text>. </xsl:text>
                </xsl:if>
                 <xsl:if test="$dcBiblioFirst != ''">
                <xsl:value-of select="$dcBiblioFirst"/>
                </xsl:if>
                <xsl:if test="$dcBiblioLast != ''">
                <xsl:text> - </xsl:text><xsl:value-of select="$dcBiblioLast"/><xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:if test="$dcRelationIspartofseries != ''">
                        <xsl:if test="contains($dcRelationIspartofseries, ';')">
                                <xsl:value-of select="substring-before($dcRelationIspartofseries, ';')"/><xsl:text> </xsl:text>
                                <xsl:value-of select="substring-after($dcRelationIspartofseries, '; ')"/>
                        </xsl:if>
                        <xsl:if test="not(contains($dcRelationIspartofseries, ';'))">
                                <xsl:value-of select="$dcRelationIspartofseries"/>
                        </xsl:if>
                        <xsl:text>.</xsl:text>
                </xsl:if>

            </fo:block>
        </xsl:if>

                </xsl:if>

<!-- #### workingPaper #### -->
        <xsl:if test="$dcType = 'workingPaper'">

        <xsl:if test="$dcTitle != ''">
           <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <xsl:text>&quot;</xsl:text><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
				
                <xsl:text>.&quot; </xsl:text>
                                <xsl:if test="$dcRelationVolume != ''">
                        <xsl:if test="contains($dcRelationVolume, ';')">
                        <fo:inline font-style="italic"><xsl:value-of select="substring-before($dcRelationVolume, ';')"/></fo:inline>
                        </xsl:if>
                                                <xsl:if test="not(contains($dcRelationVolume, ';'))">
                                                        <fo:inline font-style="italic"><xsl:value-of select="$dcRelationVolume"/></fo:inline>
                        </xsl:if>
                                                <xsl:text>.</xsl:text>
                </xsl:if>
                                <xsl:if test="$dcDescriptionInstitution != ''">
                <xsl:text> </xsl:text><xsl:value-of select="$dcDescriptionInstitution"/>
                       <xsl:text>.</xsl:text>
               </xsl:if>
               <xsl:if test="$dcBiblioVolume != ''">
                <xsl:text> </xsl:text><xsl:value-of select="$dcBiblioVolume"/>
                        <xsl:if test="string-length($dcBiblioFirst) = 0">
                        <xsl:text>. </xsl:text>
                        </xsl:if>
                </xsl:if>
               <xsl:if test="$dcBiblioFirst != ''">
                <xsl:text>: </xsl:text><xsl:value-of select="$dcBiblioFirst"/>
                </xsl:if>
                <xsl:if test="$dcBiblioLast != ''">
                <xsl:text> - </xsl:text><xsl:value-of select="$dcBiblioLast"/><xsl:text>.</xsl:text>
                </xsl:if>


            </fo:block>
        </xsl:if>

        </xsl:if>

<!-- #### conferencereport #### -->
        <xsl:if test="$dcType = 'conferenceReport'">

     			
		<xsl:if test="$dcTitle != ''">
           <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <fo:inline font-style="italic"><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
                                </fo:inline>
				
				
                <xsl:text>. </xsl:text>
                                <xsl:if test="$dcRelationEventlocation != ''">
                                         <xsl:value-of select="$dcRelationEventlocation"/>
                        </xsl:if>
                        <xsl:text>, </xsl:text>
						<xsl:if test="$dcRelationEventstart != ''">
                                        <xsl:value-of
select="substring($dcRelationEventstart,9,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring($dcRelationEventstart,6,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring($dcRelationEventstart,1,4)"/>
                        </xsl:if>
						
		<xsl:if test="$dcRelationEventend != ''">
                          <xsl:text> - </xsl:text><xsl:value-of
select="substring($dcRelationEventend,9,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring($dcRelationEventend,6,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring($dcRelationEventend,1,4)"/><xsl:text>. </xsl:text>
                        </xsl:if>
						
<xsl:if test="$dcContributorOrganiser != ''">
                <xsl:call-template name="join-elements">
                    <xsl:with-param name="elements" select="$dcContributorOrganiser" />
                    <xsl:with-param name="delimiter" select="'; '" />
                </xsl:call-template>
                                <xsl:if test="$dcContributorOrganisertwo != ''">
                                <xsl:text>, </xsl:text><xsl:value-of select="$dcContributorOrganisertwo" />
                                </xsl:if>
                                <xsl:if test="$dcContributorOrganiserthree != ''">
                                <xsl:text>, </xsl:text><xsl:value-of select="$dcContributorOrganiserthree" />
                                </xsl:if>
                <xsl:text>. </xsl:text>
        </xsl:if>




                <xsl:if test="$dcContributorOrganizedby != ''">
                          <xsl:text>Organized by  </xsl:text>

			  <xsl:call-template name="join-elements-names">
			<xsl:with-param name="elements" select="$dcContributorOrganizedby" />
                    <xsl:with-param name="delimiter" select="', '" />
                </xsl:call-template>
                        </xsl:if>
   <xsl:text>. </xsl:text>
            </fo:block>
        </xsl:if>

        </xsl:if>



<!-- #### conferencetypes #### -->
        <xsl:if test="$dcType = 'conferenceBoA' or $dcType = 'conferenceCall' or $dcType = 'conferenceProg' or $dcType = 'conferencePaper'">

     			
		<xsl:if test="$dcTitle != ''">
           <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <fo:inline font-style="italic"><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
                                </fo:inline>
				
				
                <xsl:text>. </xsl:text>
                                <xsl:if test="$dcRelationEventlocation != ''">
                                         <xsl:value-of select="$dcRelationEventlocation"/>
                        </xsl:if>
                        <xsl:text>, </xsl:text>
						<xsl:if test="$dcRelationEventstart != ''">
                                        <xsl:value-of
select="substring($dcRelationEventstart,9,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring($dcRelationEventstart,6,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring($dcRelationEventstart,1,4)"/>
                        </xsl:if>
						
		<xsl:if test="$dcRelationEventend != ''">
                          <xsl:text> - </xsl:text><xsl:value-of
select="substring($dcRelationEventend,9,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring($dcRelationEventend,6,2)"/><xsl:text>.</xsl:text><xsl:copy-of
select="substring($dcRelationEventend,1,4)"/><xsl:text>. </xsl:text>
                        </xsl:if>
						
                <xsl:if test="$dcContributorOrganizedby != ''">
                          <xsl:text>Organized by  </xsl:text>

			  <xsl:call-template name="join-elements-names">
			<xsl:with-param name="elements" select="$dcContributorOrganizedby" />
                    <xsl:with-param name="delimiter" select="', '" />
                </xsl:call-template>
                        </xsl:if>
   <xsl:text>. </xsl:text>
            </fo:block>
        </xsl:if>

        </xsl:if>


<!-- ####report #### -->
        <xsl:if test="$dcType = 'report'">

              <xsl:if test="$dcTitle != ''">
               <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <xsl:text>&quot;</xsl:text><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
                <xsl:text>.&quot; </xsl:text>
		
		<xsl:if test="$dcRelationJournal != ''">

                        <xsl:value-of select="$dcRelationJournal"/>
                        <xsl:if test="string-length($dcBiblioVolume) = 0 and string-length($dcBiblioIssue) = 0 and string-length($dcBiblioArticle) = 0">
                        <xsl:text>. </xsl:text>
                        </xsl:if>

                </xsl:if>

          
               <xsl:if test="$dcContributorEditor != ''">
<xsl:if test="count($dimNode/dim:field[@element='contributor'][@qualifier='editor']) = 1">
                         <xsl:text>Ed. </xsl:text>
                        </xsl:if>
                        <xsl:if test="count(dim:field[@element='contributor'][@qualifier='editor']) &gt; 1">
                         <xsl:text>Eds. </xsl:text>
                        </xsl:if>
            
                <xsl:call-template name="join-elements-names">
                    <xsl:with-param name="elements" select="$dcContributorEditor" />
                    <xsl:with-param name="delimiter" select="'; '" />
                </xsl:call-template>
		<xsl:text>. </xsl:text>
           
        </xsl:if>

	<xsl:if test="$dcPublishedIn != ''">
                        <xsl:value-of select="$dcPublishedIn"/>
                        <xsl:text>: </xsl:text>
                </xsl:if>

                                <xsl:if test="$dcPublisher != ''">
                        <xsl:value-of select="$dcPublisher"/>
                <xsl:text>. </xsl:text>
                </xsl:if>

                <xsl:if test="$dcBiblioVolume != ''">
                <xsl:text> </xsl:text><xsl:value-of select="$dcBiblioVolume"/>
                        
                        <xsl:text>. </xsl:text>
                    
                </xsl:if>
               
            </fo:block>
        </xsl:if>

        </xsl:if>

<!-- #### courseDescription, syllabus #### -->
        <xsl:if test="$dcType = 'courseDescription' or $dcType = 'syllabus'">

        <xsl:if test="$dcTitle != ''">
           <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <fo:inline font-style="italic"><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
                                </fo:inline>
                <xsl:text>. </xsl:text>

                                <xsl:if test="$dcDescriptionSeminar != ''">
                        <xsl:value-of select="$dcDescriptionSeminar"/>
                        <xsl:text>. </xsl:text>
                </xsl:if>

                                <xsl:if test="$dcDescriptionLocation != ''">
                        <xsl:value-of select="$dcDescriptionLocation"/>
                        <xsl:text>, </xsl:text>
                </xsl:if>

                <xsl:if test="$dcDescriptionInstitution != ''">
                        <xsl:value-of select="$dcDescriptionInstitution"/>
                        <xsl:text>, </xsl:text>
                </xsl:if>

                                <xsl:if test="$dcDescriptionSemester != ''">
                        <xsl:value-of select="$dcDescriptionSemester"/>
                        <xsl:text>. </xsl:text>
                </xsl:if>

            </fo:block>
        </xsl:if>
         </xsl:if>


	<!-- #### dissertation #### -->
        <xsl:if test="$dcType = 'dissertation'">

        <xsl:if test="$dcTitle != ''">
           <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <fo:inline font-style="italic"><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
                                </fo:inline>
                <xsl:text>. </xsl:text>

                                <xsl:if test="$dcRelationUniversity != ''">
                        <xsl:value-of select="$dcRelationUniversity"/>
                        
                </xsl:if>

                                <xsl:if test="$dcDateSubmitted != ''">
                        <xsl:text>, </xsl:text><xsl:value-of select="$dcDateSubmitted"/>
                       
                </xsl:if>
                <xsl:text>. </xsl:text>
            </fo:block>
        </xsl:if>
         </xsl:if>

	    <!-- #### lecture #### -->
        <xsl:if test="$dcType = 'lecture'">

        <xsl:if test="$dcTitle != ''">
           <fo:block font-size="18pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                <xsl:text>&quot;</xsl:text><xsl:value-of select="$dcTitle"/>
                <xsl:if test="$dcTitleSubtitle != ''">
                    <xsl:text>: </xsl:text><xsl:value-of select="$dcTitleSubtitle"/>
                </xsl:if>
				
                <xsl:text>.&quot; </xsl:text>
               <xsl:if test="$dcRelationEventlocation != ''">
                        <xsl:value-of select="$dcRelationEventlocation"/>
                        <xsl:text>, </xsl:text>
                </xsl:if>
               <xsl:if test="$dcRelationEventstart != ''">
                        <xsl:value-of select="$dcRelationEventstart"/>
                        <xsl:text>. </xsl:text>
                </xsl:if>
               
               <xsl:if test="$dcPublishedIn != ''">
                        <xsl:value-of select="$dcPublishedIn"/>
                        <xsl:text>: </xsl:text>
                </xsl:if>

                                <xsl:if test="$dcPublisher != ''">
                        <xsl:value-of select="$dcPublisher"/>
                        <xsl:text>. </xsl:text>
                </xsl:if>
               
               
                                <xsl:if test="$dcRelationVolume != ''">
                        <xsl:if test="contains($dcRelationVolume, ';')">
                        <xsl:value-of select="substring-before($dcRelationVolume, ';')"/>
                        </xsl:if>
                        <xsl:if test="not(contains($dcRelationVolume, ';'))">
                                        <xsl:value-of select="$dcRelationVolume"/>
                        </xsl:if>
                        <xsl:text>.</xsl:text>
                </xsl:if>

            </fo:block>
        </xsl:if>

        </xsl:if>

<!--    <xsl:if test="$dcRights != ''">
            <fo:block font-size="13pt" start-indent="5mm" end-indent="5mm">
                <xsl:if test="contains($dcRights, 'The Stacks License')" />
                        <xsl:text>The Stacks Lizenz: https://thestacks.libaac.de/rights</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY 4.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by/4.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY 3.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by/3.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY 2.5')" />
                        <xsl:text>https://creativecommons.org/licenses/by/2.5/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY 2.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by/2.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY 1.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by/1.0/</xsl:text>
                </xsl:if>

                <xsl:if test="contains($dcRights, 'CC BY-NC 4.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc/4.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC 3.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc/3.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC 2.5')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc/2.5/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC 2.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc/2.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC 1.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc/1.0/</xsl:text>
                </xsl:if>

                <xsl:if test="contains($dcRights, 'CC BY-NC-SA 4.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-sa/4.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC-SA 3.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-sa/3.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC-SA 2.5')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-sa/2.5/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC-SA 2.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-sa/2.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC-SA 1.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-sa/1.0/</xsl:text>
                </xsl:if>

                <xsl:if test="contains($dcRights, 'CC BY-SA 4.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-sa/4.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-SA 3.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-sa/3.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-SA 2.5')" />
                        <xsl:text>https://creativecommons.org/licenses/by-sa/2.5/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-SA 2.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-sa/2.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-SA 1.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-sa/1.0/</xsl:text>
                </xsl:if>

                <xsl:if test="contains($dcRights, 'CC BY-ND 4.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nd/4.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-ND 3.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nd/3.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-ND 2.5')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nd/2.5/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-ND 2.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nd/2.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-ND 1.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nd/1.0/</xsl:text>
                </xsl:if>

                <xsl:if test="contains($dcRights, 'CC BY-NC-ND 4.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-nd/4.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC-ND 3.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-nd/3.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC-ND 2.5')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-nd/2.5/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC-ND 2.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-nd/2.0/</xsl:text>
                </xsl:if>
                <xsl:if test="contains($dcRights, 'CC BY-NC-ND 1.0')" />
                        <xsl:text>https://creativecommons.org/licenses/by-nc-nd/1.0/</xsl:text>
                </xsl:if>

            </fo:block>
        </xsl:if>-->

<fo:block font-size="10pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm">

		<xsl:if test="$dcType != ''">
                <fo:block padding-before="0.1cm" start-indent="5mm" end-indent="5mm">
                    <xsl:choose>
                        <xsl:when test="$dcType = 'anthologyArticle'">
                            <xsl:text>Sammelbandbeitrag / Article in Anthology</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'article'">
                            <xsl:text>Zeitschriftenartikel / Journal Article</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'monograph'">
                            <xsl:text>Monographie / Monograph</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'dissertation'">
                            <xsl:text>Dissertation</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'workingPaper'">
                            <xsl:text>Arbeitspapier / Working Paper</xsl:text>
                        </xsl:when>

                        <xsl:when test="$dcType = 'anthology'">
                            <xsl:text>Sammelband / Anthology</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'review'">
                            <xsl:text>Rezension / Review</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'conferenceProg'">
                            <xsl:text>Konferenzprogramm / Conference Programme</xsl:text>
                        </xsl:when>
     
                        <xsl:when test="$dcType = 'conferenceReport'">
                            <xsl:text>Tagungsbericht / Conference Report</xsl:text>
                        </xsl:when>
						<xsl:when test="$dcType = 'conferenceBoA'">
                            <xsl:text>Book of Abstracts</xsl:text>
                        </xsl:when>
						<xsl:when test="$dcType = 'conferencePaper'">
                            <xsl:text>Conference Paper</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'report'">
                            <xsl:text>Report</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'bookPart'">
                            <xsl:text>Buchkapitel / Book Part</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'syllabus'">
                            <xsl:text>Seminarplan / Syllabus</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'blogentry'">
                            <xsl:text>Blog-Beitrag / Blog Entry</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcType = 'conferenceCall'">
                            <xsl:text>Call for Papers (Konferenz) / Call for Papers (Conference)</xsl:text>
                        </xsl:when>
						<xsl:when test="$dcType = 'lecture'">
                            <xsl:text>Vortrag / Lecture</xsl:text>
                        </xsl:when>
			<xsl:when test="$dcType = 'courseDescription'">
                            <xsl:text>Seminarbeschreibung / Course Description</xsl:text>
                        </xsl:when>           
                    </xsl:choose>
                </fo:block>
                </xsl:if>

            <xsl:if test="$dcTypeVersion != ''">
                <fo:block padding-before="0.2cm" start-indent="5mm" end-indent="5mm">
                    <xsl:choose>
                        <xsl:when test="$dcTypeVersion = 'publishedVersion'">
                            <xsl:text>Veröffentlichte Version / published version</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcTypeVersion = 'submittedVersion'">
                            <xsl:text>Eingereichte Version / submitted version</xsl:text>
                        </xsl:when>
                        <xsl:when test="$dcTypeVersion = 'acceptedVersion'">
                            <xsl:text>Angenommene Version / accepted version</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </fo:block>
            </xsl:if>


         <xsl:if test="$doiUrlString != ''">
          <fo:block font-size="10pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm" keep-together.within-line="always">
              <xsl:value-of select="$doiUrlString" />
          </fo:block>
        </xsl:if>
        <xsl:if test="$doiUrlString = ''">
        <xsl:if test="$dcUri != ''">
          <fo:block font-size="10pt" padding-before="0.2cm" start-indent="5mm" end-indent="5mm" keep-together.within-line="always">
              <xsl:value-of select="$dcUri" />
          </fo:block>
        </xsl:if>
        </xsl:if>

        </fo:block>
    </xsl:template>


    <xsl:template name="publishernotesBlock">
        <xsl:param name="dimNode" />
        <xsl:variable name="dcPublishernotes" select="$dimNode/dim:field[@mdschema='dc' and @element='description' and @qualifier='publisherNote']" />
        <xsl:if test="$dcPublishernotes != ''">
            <fo:block-container width="100%" display-align="after" padding-before="7mm">
                <fo:block font-size="9pt">
                    <xsl:value-of select="$dcPublishernotes"/>
                </fo:block>
            </fo:block-container>
        </xsl:if>
    </xsl:template>

    <xsl:template name="piBlock">
        <xsl:param name="dimNode" />
        <xsl:variable name="dcIdentifierPi" select="$dimNode/dim:field[@mdschema='dc' and @element='identifier' and @qualifier='pi']" />
        <xsl:if test="$dcIdentifierPi != ''">
            <xsl:variable name="identifierUrl">
                <xsl:choose>
                    <xsl:when test="contains($dcIdentifierPi, '10.')">
                        <xsl:call-template name="getDoiUrl">
                            <xsl:with-param name="rawDoi" select="$dcIdentifierPi" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains($dcIdentifierPi, 'urn:nbn')">
                        <xsl:call-template name="getUrnNbnUrl">
                            <xsl:with-param name="rawUrn" select="$dcIdentifierPi" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$dcIdentifierPi" />
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:variable>
            <fo:block-container width="100%" display-align="after" padding-before="7mm">
                <fo:block font-size="9pt" font-weight="bold">
                    <xsl:text>Erstmalig hier erschienen / Initial publication here: </xsl:text><xsl:value-of select="$identifierUrl"/>
                </fo:block>
            </fo:block-container>
        </xsl:if>
    </xsl:template>


    <xsl:template name="licenseBlock">
        <xsl:param name="dimNode"/>
        <xsl:variable name="dcRightsLicense">
            <xsl:value-of select="$dimNode/dim:field[@mdschema='dc' and @element='rights' and not(@qualifier)]/text()"/>
        </xsl:variable>

        <xsl:if test="$dcRightsLicense != ''">
            <fo:block-container position="absolute" width="100%" top="190mm">
                <fo:block>
                    <fo:table font-size="8pt">
                        <fo:table-column />
                        <fo:table-column />
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell padding-right="3mm">
                                    <fo:block font-weight="bold">
                                        <xsl:text>Nutzungsbedingungen:</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding-left="3mm">
                                    <fo:block font-weight="bold">
                                        <xsl:text>Terms of use:</xsl:text>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <xsl:choose>
                                    <xsl:when test="contains($dcRightsLicense, 'BY 4.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY 4.0 Lizenz (Namensnennung) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by/4.0/deed.de')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by/4.0/deed.de</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY 4.0 License (Attribution). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by/4.0/deed.en')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by/4.0/deed.en</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense, 'BY-SA 4.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY SA 4.0 Lizenz (Namensnennung - Weitergabe unter gleichen Bedingungen) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-sa/4.0/deed.de')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-sa/4.0/deed.de</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY SA 4.0 License (Attribution - ShareAlike). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-sa/4.0/deed.en')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-sa/4.0/deed.en</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense,'BY-NC 4.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY NC 4.0 Lizenz (Namensnennung - Nicht kommerziell) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc/4.0/deed.de')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc/4.0/deed.de</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY NC 4.0 License (Attribution - NonCommercial). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc/4.0/deed.en')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc/4.0/deed.en</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense, 'BY-NC-SA 4.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY NC SA 4.0 Lizenz (Namensnennung - Nicht kommerziell - Weitergabe unter gleichen Bedingungen) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc-sa/4.0/deed.de')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc-sa/4.0/deed.de</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY NC SA 4.0 License (Attribution - NonCommercial - ShareAlike). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense, 'BY-ND 4.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY ND 4.0 Lizenz (Namensnennung - Keine Bearbeitung) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nd/4.0/deed.de')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nd/4.0/legalcode.de</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY ND 4.0 License (Attribution - NoDerivates). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nd/4.0/deed.en')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nd/4.0/legalcode.en</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense, 'BY-NC-ND 4.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY NC ND 4.0 Lizenz (Namensnennung - Nicht kommerziell - Keine Bearbeitung) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc-nd/4.0/deed.de')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode.de</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY NC ND 4.0 License (Attribution - NonCommercial - NoDerivates). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>

                                        <xsl:when test="contains($dcRightsLicense, 'BY 3.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY 3.0 Lizenz (Namensnennung) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY 3.0 License (Attribution). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense, 'BY-SA 3.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY SA 3.0 Lizenz (Namensnennung - Weitergabe unter gleichen Bedingungen) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-sa/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-sa/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY SA 3.0 License (Attribution - ShareAlike). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-sa/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-sa/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense,'BY-NC 3.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY NC 3.0 Lizenz (Namensnennung - Nicht kommerziell) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY NC 3.0 License (Attribution - NonCommercial). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense, 'BY-NC-SA 3.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY NC SA 3.0 Lizenz (Namensnennung - Nicht kommerziell - Weitergabe unter gleichen Bedingungen) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc-sa/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc-sa/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY NC SA 3.0 License (Attribution - NonCommercial - ShareAlike). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc-sa/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc-sa/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense, 'BY-ND 3.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY ND 3.0 Lizenz (Namensnennung - Keine Bearbeitung) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nd/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nd/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY ND 3.0 License (Attribution - NoDerivates). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nd/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nd/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>
                                    <xsl:when test="contains($dcRightsLicense, 'BY-NC-ND 3.0')">
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>Dieser Text wird unter einer CC BY NC ND 3.0 Lizenz (Namensnennung - Nicht kommerziell - Keine Bearbeitung) zur Verfügung gestellt. Nähere Auskünfte zu dieser Lizenz finden Sie hier:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc-nd/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc-nd/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block>
                                                <fo:inline>This document is made available under a CC BY NC ND 3.0 License (Attribution - NonCommercial - NoDerivates). For more information see:</fo:inline>
                                                <fo:block>
                                                    <fo:basic-link external-destination="url('https://creativecommons.org/licenses/by-nc-nd/3.0')" color="blue" text-decoration="underline">
                                                        <xsl:text>https://creativecommons.org/licenses/by-nc-nd/3.0</xsl:text>
                                                    </fo:basic-link>
                                                </fo:block>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:when>


                                    <xsl:otherwise>
                                        <fo:table-cell padding-right="3mm" text-align="justify">
                                            <fo:block><xsl:text>Mit der Verwendung dieses Dokuments erkennen Sie die </xsl:text>
                                                <fo:basic-link external-destination="url('https://thestacks.libaac.de/rights')" color="blue">
                                                        <xsl:text>Nutzungsbedingungen</xsl:text>
                                                    </fo:basic-link>
                                                <xsl:text> an.</xsl:text>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell padding-left="3mm" text-align="justify">
                                            <fo:block><xsl:text>By using this particular document, you accept the </xsl:text>
                                                <fo:basic-link external-destination="url('https://thestacks.libaac.de/rights')" color="blue">
                                                        <xsl:text>terms of use</xsl:text>
                                                    </fo:basic-link>
                                                <xsl:text> stated above.</xsl:text>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:block>
            </fo:block-container>
        </xsl:if>
    </xsl:template>


<xsl:template name="join-elements-names">
        <xsl:param name="elements" />
        <xsl:param name="delimiter" />
        <xsl:for-each select="$elements">
	<xsl:value-of select="substring-after(./text(), ', ')" />
	<xsl:text> </xsl:text><xsl:value-of select="substring-before(./text(), ', ')" />
            <xsl:if test="position() != last()">
                <xsl:value-of select="$delimiter" />
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="join-elements">
        <xsl:param name="elements" />
        <xsl:param name="delimiter" />
        <xsl:for-each select="$elements">
            <xsl:value-of select="./text()" />
            <xsl:if test="position() != last()">
                <xsl:value-of select="$delimiter" />
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="getDoiWithoutPrefix">
        <xsl:param name="rawDoi" />
        <xsl:choose>
            <xsl:when test="contains($rawDoi, '//dx.doi.org/')">
                <xsl:value-of select="substring-after($rawDoi, '//dx.doi.org/')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$rawDoi"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="getDoiUrl">
        <xsl:param name="rawDoi" />

        <xsl:if test="$rawDoi != ''">
            <xsl:variable name="pureDoi">
                <xsl:call-template name="getDoiWithoutPrefix">
                    <xsl:with-param name="rawDoi" select="$rawDoi" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="concat('https://doi.org/', $pureDoi)" />
        </xsl:if>

    </xsl:template>


    <xsl:template name="getUrnNbnUrl">
        <xsl:param name="rawUrn" />

        <xsl:if test="$rawUrn != ''">
            <xsl:value-of select="concat('https://nbn-resolving.org/', $rawUrn)" />
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
