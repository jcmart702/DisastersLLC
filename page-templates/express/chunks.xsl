<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="xlink">

  <!-- Handles ContentWidth chunks -->
  <xsl:template match="chunk[meta[@name = 'Content-Group']/value = 'Section']" mode="chunk">
    <xsl:param name="siblings" />
    <xsl:variable name="bucket" select="./meta[@name = 'Content-Group']/value" />

    <xsl:if test="position() = 1">
      <xsl:apply-templates select="$siblings">
        <xsl:with-param name="style_formats" select="'.style-formats'" />
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>