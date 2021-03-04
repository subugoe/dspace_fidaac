<?xml version="1.0"?>
<xsl:stylesheet
	xmlns:srw="http://www.loc.gov/zing/srw/"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/"
	xmlns:xcql="http://www.loc.gov/zing/cql/xcql/"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:pica="info:srw/schema/5/picaXML-v1.0"
	version="1.0"
        exclude-result-prefixes="srw dc diag xcql pica xsi">

<xsl:output indent="yes" encoding="UTF-8" method="xml" />                  

<xsl:template match="*"/>
<xsl:strip-space elements="*" />

	

<xsl:template match="/srw:searchRetrieveResponse">
	
    <xsl:apply-templates select="srw:records/srw:record"/>
</xsl:template>


<xsl:template match="srw:records/srw:record">
     <xsl:apply-templates select="srw:recordData/pica:record"/>
  </xsl:template>



<xsl:template match="srw:recordData/pica:record">
  <dim:dim>
    <xsl:call-template name="linebreak" />  
    <xsl:apply-templates />
     <xsl:call-template name="freeKeywords" />
     <xsl:call-template name="bibliographicCitation" />
    </dim:dim>
</xsl:template>


  <!-- pica 003, 004: identifier -->
  <xsl:template match="pica:datafield[@tag='003@']">
        <dim:field element="identifier" qualifier="ppn">
                <xsl:value-of select="pica:subfield[@code='0']" />
        </dim:field>
                <xsl:call-template name="linebreak" />  
    </xsl:template>


  <!-- 010@: language -->
    <xsl:template match="pica:datafield[@tag='010@']">

        <dim:field element="language" qualifier="iso">
                <xsl:value-of select="pica:subfield[@code='a']" />
                
        </dim:field>
                <xsl:call-template name="linebreak" />  
   </xsl:template>

  <!-- 021A:title -->

<xsl:template match="pica:datafield[@tag='021A']">
        <dim:field element="title">
                <xsl:value-of select="translate(pica:subfield[@code='a'], '@', '')" />
        </dim:field>
                <xsl:call-template name="linebreak" />
        <xsl:if test="pica:subfield[@code='f']">
                <dim:field element="title" qualifier="translated">
                        <xsl:value-of select="translate(pica:subfield[@code='f'], '@', '')" />
                 </dim:field>
                <xsl:call-template name="linebreak" />
        </xsl:if>
        <xsl:if test="pica:subfield[@code='d']">
          <dim:field element="title" qualifier="alternative">
                <xsl:value-of select="translate(pica:subfield[@code='d'], '@', '')" />
         </dim:field>
                <xsl:call-template name="linebreak" />
        </xsl:if>
   </xsl:template>


<!--Issued-->
<xsl:template match="pica:datafield[@tag='011@']">
        <dim:field element="date" qualifier="issued">
                <xsl:value-of select="pica:subfield[@code='a']" />
                
        </dim:field>
                <xsl:call-template name="linebreak" />  
   </xsl:template>

<!-- 028X: Autoren [a: Nachname, d: Vorname; 028A erster Autor, weitere 028B wiederholbar]-->

  <xsl:template match="pica:datafield[@tag='028A']">

        <dim:field element="contributor" qualifier="author">
                <xsl:value-of select="pica:subfield[@code='a']" />
                <xsl:text>, </xsl:text>
                <xsl:value-of select="pica:subfield[@code='d']" />
        </dim:field>
                <xsl:call-template name="linebreak" />  
   </xsl:template>

   <xsl:template match="pica:datafield[@tag='028B']">
	<xsl:for-each select=".">
        <dim:field element="contributor" qualifier="author">
                <xsl:value-of select="pica:subfield[@code='a']" />
                <xsl:text>, </xsl:text>
                <xsl:value-of select="pica:subfield[@code='d']" />
        </dim:field>
                <xsl:call-template name="linebreak" />  
	</xsl:for-each>
   </xsl:template>

   <!-- 028C: Editoren, gefeierte Person uws. nicht unterscheidbar [a: Nachname, d: Vorname]-->

  <xsl:template match="pica:datafield[@tag='028C']">

        <dim:field element="contributor" qualifier="editor">
                <xsl:value-of select="pica:subfield[@code='a']" />
                <xsl:text>, </xsl:text>
                <xsl:value-of select="pica:subfield[@code='d']" />
        </dim:field>
                <xsl:call-template name="linebreak" />  
   </xsl:template>

      <!-- 033A: vom Doktyp abhängig - Bücher (Oau): Verlagsdaten [pica:subfields p: Verlagsort, n: Verleger], Artikel(Osu): bibl.Angaben zur Zeitschrift [subfields[d: Band, e: Heftnr, h: Seiten, j: Jahr]-->
   <xsl:template match="pica:datafield[@tag='033A']">
          
                <dim:field element="publisher">
                  <xsl:value-of select="pica:subfield[@code='n']" />
		  <xsl:if test="pica:subfield[@code='p']">
			<xsl:text>, </xsl:text><xsl:value-of select="pica:subfield[@code='p']" />
		  </xsl:if>
                </dim:field>
                <xsl:call-template name="linebreak" />  
                
   </xsl:template>


  <!-- 034D: Format und Umfang -->
   <xsl:template match="pica:datafield[@tag='034D']">

          <xsl:variable name="pure"><xsl:value-of select="pica:subfield[@code='a']" /></xsl:variable>
                <xsl:if test="contains($pure, '(')">
                  <xsl:variable name="fvalue"><xsl:value-of select="substring-after($pure, '(')" /></xsl:variable>
                <dim:field element="format" qualifier="extent">
                  <xsl:value-of select="translate($fvalue, '()', '')" />
                </dim:field>
                <xsl:call-template name="linebreak" />
                </xsl:if>


   </xsl:template>



    <!-- 046I: abstract -->
    <xsl:template match="pica:datafield[@tag='047I']">
        <dim:field element="description" qualifier="abstract">
                <xsl:value-of select="pica:subfield[@code='a']" />

        </dim:field>
                <xsl:call-template name="linebreak" />
   </xsl:template>


</xsl:stylesheet>


