<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="style-formats">
    <xsl:text disable-output-escaping='yes'><![CDATA[
      [

  {"title": "Text", "items":[
  {"title": "Team Member Title", "selector":"p,h1,h2,h3,h4,h5,h6","classes":"team-title"},
  {"title": "Button", "selector": "a", "classes": "button"}
]}
  ]]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
