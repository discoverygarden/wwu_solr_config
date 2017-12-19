<?xml version="1.0" encoding="UTF-8"?>
<!-- Template to make the iso8601 date -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:java="http://xml.apache.org/xalan/java">

  <xsl:template name="get_ISO8601_date">
    <xsl:param name="date"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>

    <xsl:value-of select="java:ca.discoverygarden.gsearch_extensions.JodaAdapter.transformForSolr($date, $pid, $datastream)"/>
  </xsl:template>

  <xsl:template name="get_ISO8601_edtf_date">
    <xsl:param name="date"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>

    <!-- EDTF stores unknown numbers as 'u' or 'U'; normalizing to 0. -->
    <!-- Only regard the portion of the date before a '/', as this indicates a
         range we wish to round down. -->
    <xsl:variable name="translated_date">
      <xsl:choose>
        <xsl:when test="contains($date, '/')">
          <xsl:value-of select="translate(substring-before($date, '/'), 'uU', '00')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate($date, 'uU', '00')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Round down approximations as well; these either end in '?' or '~'. -->
    <xsl:variable name="date_prefix">
      <xsl:choose>
        <xsl:when test="contains($translated_date, '?')">
          <xsl:value-of select="substring-before($translated_date, '?')"/>
        </xsl:when>
        <xsl:when test="contains($translated_date, '~')">
          <xsl:value-of select="substring-before($translated_date, '~')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$translated_date"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="get_ISO8601_date">
      <xsl:with-param name="date" select="$date_prefix"/>
      <xsl:with-param name="pid" select="$pid"/>
      <xsl:with-param name="datastream" select="$datastream"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
