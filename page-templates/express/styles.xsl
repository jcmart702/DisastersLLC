<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="xlink">

  <!-- Tiny MCE style sheet selection -->
  <xsl:template name="style-formats">
    <xsl:text disable-output-escaping='yes'><![CDATA[
      [
  {"title": "Section", "items":[
  {"title": "Vertically Center Columns", "selector":"section","classes":"vertical-center"},
  {"title": "Reduce Padding", "selector":"section","classes":"reduced-padding"},
  {"title": "Background Yellow", "selector":"section","classes":"bg-warning"},
  {"title": "Background Gray", "selector":"section","classes":"bg-gray"},
  {"title": "Background Gray Circles", "selector":"section","classes":"gray-circles-left"},
  {"title": "Background Yellow Circles", "selector":"section","classes":"circle-pattern"},
  {"title": "Bottom Border", "selector":"section","classes":"border-bottom"}
]},
  {"title": "Text", "items":[
  {"title": "Orange Text", "selector":"p,h1,h2,h3,h4,h5,h6","classes":"text-primary"}
]},
  {"title": "Button", "items":[
  {"title": "Button", "selector": "a", "classes": "btn btn-primary"},
  {"title": "Button Color - Primary", "selector": "a.btn", "classes": "btn-primary"},
  {"title": "Button Color - Success", "selector": "a.btn", "classes": "btn-success"},
  {"title": "Button Color - Info", "selector": "a.btn", "classes": "btn-info"},
  {"title": "Button Color - Warning", "selector": "a.btn", "classes": "btn-warning"},
  {"title": "Button Color - Danger", "selector": "a.btn", "classes": "btn-danger"},
  {"title": "Button Color - Default", "selector": "a.btn", "classes": "btn-default"},
  {"title": "Hover The Button", "selector":".btn","classes":"hover-flatten"}
]},
  {"title": "List", "items":[
  {"title": "List Unstyled", "selector":"ul","classes":"list-unstyled"},
  {"title": "List Inline ", "selector":"ul","classes":"list-inline"}
]},
  {"title": "Panel", "items":[

  {"title": "Panel Primary", "selector":".panel","classes":"panel-primary"},
  {"title": "Panel Success", "selector":".panel","classes":"panel-success"},
  {"title": "Panel Info", "selector":".panel","classes":"panel-info"},
  {"title": "Panel Warning", "selector":".panel","classes":"panel-warning"},
  {"title": "Panel Danger", "selector":".panel","classes":"panel-danger"}
]},
  {"title": "Blockquote", "items":[

  {"title": "Blockquote Reverse","selector":"blockquote","classes":"blockquote-reverse"}
]},
  {"title": "Image", "items":[

  {"title": "Wavy", "selector":"img","classes":"wavy"}
]},
  {"title": "Small", "inline":"small"}]]]></xsl:text>
  </xsl:template>

</xsl:stylesheet>