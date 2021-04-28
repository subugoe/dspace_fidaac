<?xml version="1.0" encoding="UTF-8" ?>
<!--


    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/
        Developed by DSpace @ Lyncode <dspace@lyncode.com>

        > http://www.openarchives.org/OAI/2.0/oai_dc.xsd

 -->
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://www.lyncode.com/xoai"
        version="1.0">
        <xsl:output omit-xml-declaration="yes" method="xml" indent="yes" />

        <xsl:template match="/">
                <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                        xmlns:dc="http://purl.org/dc/elements/1.1/"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
                        <!-- dc.title -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field[@name='value']">
                                <dc:title>
                                <xsl:value-of select="." />
                                <xsl:if test="../../doc:element[@name='alternative']/doc:element/doc:field[@name='value']">
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="../../doc:element[@name='alternative']/doc:element/doc:field[@name='value']"/>
                                </xsl:if>
                                </dc:title>
                        </xsl:for-each>
                        <!-- dc.title.* -->
                        <!--<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:title><xsl:value-of select="." /></dc:title>
                        </xsl:for-each>-->
                        <!-- dc.creator -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='creator']/doc:element/doc:field[@name='value']">
                                <dc:creator><xsl:value-of select="." /></dc:creator>
                        </xsl:for-each>
                        <!-- dc.contributor.author -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field[@name='value']">
                                <dc:creator><xsl:value-of select="." /></dc:creator>
                        </xsl:for-each>
                        <!-- dc.contributor.* (!author) -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name!='author']/doc:element/doc:field[@name='value']">
                                <dc:contributor><xsl:value-of select="." /></dc:contributor>
                        </xsl:for-each>
                        <!-- dc.contributor -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element/doc:field[@name='value']">
                                <dc:contributor><xsl:value-of select="." /></dc:contributor>
                        </xsl:for-each>
                        <!-- dc.subject -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element/doc:field[@name='value']">
                                <dc:subject><xsl:value-of select="." /></dc:subject>
                        </xsl:for-each>
                        <!-- dc.subject.* -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:subject><xsl:value-of select="." /></dc:subject>
                        </xsl:for-each>
						<!-- dc.subject.ddc -->
			<!--<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']/doc:element[@name='ddc']/doc:element/doc:field[@name='value']">
					<dc:subject><xsl:value-of select="." /></dc:subject>
			</xsl:for-each>-->
                        <!-- dc.description -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element/doc:field[@name='value']">
                                <dc:description><xsl:value-of select="." /></dc:description>
                        </xsl:for-each>
                        <!-- dc.description.* (not provenance)-->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name!='provenance']/doc:element/doc:field[@name='value']">
                                <dc:description><xsl:value-of select="." /></dc:description>
                        </xsl:for-each>
                        <!-- dc.date -->
                        <!--<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element/doc:field[@name='value']">
                                <dc:date><xsl:value-of select="." /></dc:date>
                        </xsl:for-each>-->
                        <!-- dc.date.issued -->
			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field[@name='value']">
				<dc:date><xsl:value-of select="substring(.,0,11)" /></dc:date>
			</xsl:for-each>
                        <!-- dc.type MODIFIED: dini conformity -->

			<xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element/doc:field[@name='value']">
                                <xsl:if test=". = 'article' ' or . = 'blogentry'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'article')" /></dc:type>
                                </xsl:if>
                                <xsl:if test=". = 'syllabus' or . = 'courseDescription'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'courseMaterial')" /></dc:type>
                                </xsl:if>
                                <xsl:if test=". = 'monograph' or . = 'anthology'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'book')" /></dc:type>
                                </xsl:if>
				
				<xsl:if test=". = 'anthologyArticle'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'bookPart')" /></dc:type>
                                </xsl:if>
                                <xsl:if test="starts-with(., 'conference')">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'conferenceObject')" /></dc:type>
                                </xsl:if>
                                <xsl:if test=". = 'dissertation'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'doctoralThesis')" /></dc:type>
                                </xsl:if>

				<xsl:if test=". = 'report'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'report')" /></dc:type>
                                </xsl:if>
                                <xsl:if test=". = 'review'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'review')" /></dc:type>
                                </xsl:if>
                                <xsl:if test=". = 'prepublication' or . = 'preprint'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'preprint')" /></dc:type>
                                </xsl:if>


				<xsl:if test=". = 'workingPaper'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'workingPaper')" /></dc:type>
                                </xsl:if>
                                <xsl:if test=". = 'prepublication' or . = 'lecture'">
                                <dc:type><xsl:value-of select="concat('doc-type:', 'lecture')" /></dc:type>
                                </xsl:if>
				
                        </xsl:for-each>
                        <!-- dc.type.* -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='type']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:type><xsl:value-of select="." /></dc:type>
                        </xsl:for-each>
                        <!-- dc.identifier -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element/doc:field[@name='value']">
                                <dc:identifier><xsl:value-of select="." /></dc:identifier>
                        </xsl:for-each>
                        <!-- dc.identifier.* -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:identifier><xsl:value-of select="." /></dc:identifier>
                        </xsl:for-each>
                        <!-- dc.language -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='language']/doc:element/doc:field[@name='value']">
                                <dc:language><xsl:value-of select="." /></dc:language>
                        </xsl:for-each>
                        <!-- dc.language.* -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='language']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:language><xsl:value-of select="." /></dc:language>
                        </xsl:for-each>
                        <!-- dc.relation -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:field[@name='value']">
                                <dc:relation><xsl:value-of select="." /></dc:relation>
                        </xsl:for-each>
                        <!-- dc.relation.* -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:relation><xsl:value-of select="." /></dc:relation>
                        </xsl:for-each>
                        <!-- dc.rights -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field[@name='value']">
                                <dc:rights><xsl:value-of select="." /></dc:rights>
                        </xsl:for-each>
								<xsl:choose>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::The Stacks License'">
								<dc:rights>https://thestacks.libaac.de/rights</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC 1.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc/1.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC 2.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc/2.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC 2.5'">
								<dc:rights>https://creativecommons.org/licenses/by-nc/2.5/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC 3.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc/3.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC 4.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc/4.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY 1.0'">
								<dc:rights>https://creativecommons.org/licenses/by/1.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY 2.0'">
								<dc:rights>https://creativecommons.org/licenses/by/2.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY 2.5'">
								<dc:rights>https://creativecommons.org/licenses/by/2.5/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY 3.0'">
								<dc:rights>https://creativecommons.org/licenses/by/3.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY 4.0'">
								<dc:rights>https://creativecommons.org/licenses/by/4.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-SA 1.0'">
								<dc:rights>https://creativecommons.org/licenses/by-sa/1.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-SA 2.0'">
								<dc:rights>https://creativecommons.org/licenses/by-sa/2.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-SA 2.5'">
								<dc:rights>https://creativecommons.org/licenses/by-sa/2.5/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-SA 3.0'">
								<dc:rights>https://creativecommons.org/licenses/by-sa/3.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-SA 4.0'">
								<dc:rights>https://creativecommons.org/licenses/by-sa/4.0/</dc:rights></xsl:when>
								
								
								
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-ND 1.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nd/1.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-ND 2.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nd/2.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-ND 2.5'">
								<dc:rights>https://creativecommons.org/licenses/by-nd/2.5/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-ND 3.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nd/3.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-ND 4.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nd/4.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-ND 1.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-nd/1.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-ND 2.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-nd/2.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-ND 2.5'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-nd/2.5/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-ND 3.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-nd/3.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-ND 4.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-nd/4.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-SA 1.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-sa/1.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-SA 2.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-sa/2.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-SA 2.5'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-sa/2.5/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-SA 3.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-sa/3.0/</dc:rights></xsl:when>
								<xsl:when test="doc:metadata/doc:element[@name='dc']/doc:element[@name='rights']/doc:element/doc:field = 'L::CC BY-NC-SA 4.0'">
								<dc:rights>https://creativecommons.org/licenses/by-nc-sa/4.0/</dc:rights></xsl:when>
								</xsl:choose>
                        <!-- dc.format -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='format']/doc:element/doc:field[@name='value']">
                                <dc:format><xsl:value-of select="." /></dc:format>
                        </xsl:for-each>
                        <!-- dc.format.* -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='format']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:format><xsl:value-of select="." /></dc:format>
                        </xsl:for-each>
                        <!-- ? -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='bitstreams']/doc:element[@name='bitstream']/doc:field[@name='format']">
                                <dc:format><xsl:value-of select="." /></dc:format>
                        </xsl:for-each>
                        <!-- dc.coverage -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='coverage']/doc:element/doc:field[@name='value']">
                                <dc:coverage><xsl:value-of select="." /></dc:coverage>
                        </xsl:for-each>
                        <!-- dc.coverage.* -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='coverage']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:coverage><xsl:value-of select="." /></dc:coverage>
                        </xsl:for-each>
                        <!-- dc.publisher -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field[@name='value']">
                                <dc:publisher><xsl:value-of select="." /></dc:publisher>
                        </xsl:for-each>
                        <!-- dc.publisher.* -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:publisher><xsl:value-of select="." /></dc:publisher>
                        </xsl:for-each>
                        <!-- dc.source -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element/doc:field[@name='value']">
                                <dc:source><xsl:value-of select="." /></dc:source>
                        </xsl:for-each>
                        <!-- dc.source.* -->
                        <xsl:for-each select="doc:metadata/doc:element[@name='dc']/doc:element[@name='source']/doc:element/doc:element/doc:field[@name='value']">
                                <dc:source><xsl:value-of select="." /></dc:source>
                        </xsl:for-each>
                </oai_dc:dc>
        </xsl:template>
</xsl:stylesheet>
