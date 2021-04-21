<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="GOOGLE_MAPS_API_KEY">AIzaSyCPVhgCrbKphv-w7237f12b3huFVJTg21w</xsl:variable>

  <xsl:template name="google-static-map">
    <xsl:param name="address" />
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:param name="zoom" select="15" />
    <xsl:param name="scale" />
    <xsl:param name="format" />
    <xsl:param name="maptype" />
    <xsl:param name="style" />
    <xsl:param name="key" select="$GOOGLE_MAPS_API_KEY" />

    <img width="{$width}" height="{$height}" alt="Google Maps at {$address}">
      <xsl:attribute name="src">
        <xsl:text>//maps.googleapis.com/maps/api/staticmap?</xsl:text>
        <xsl:text>center=</xsl:text>
        <xsl:value-of select="translate($address, ' ', '+')" />
        <xsl:if test="$zoom != ''">
          <xsl:value-of select="concat('&amp;zoom=', $zoom)" />
        </xsl:if>
        <xsl:value-of select="concat('&amp;size=', $width, 'x', $height)" />
        <xsl:if test="$scale != ''">
          <xsl:value-of select="concat('&amp;scale=', $scale)" />
        </xsl:if>
        <xsl:if test="$format != ''">
          <xsl:value-of select="concat('&amp;format=', $format)" />
        </xsl:if>
        <xsl:if test="$maptype != ''">
          <xsl:value-of select="concat('&amp;maptype=', $maptype)" />
        </xsl:if>
        <xsl:if test="$style != ''">
          <xsl:value-of select="concat('&amp;style=', $style)" />
        </xsl:if>
        <xsl:if test="$key != ''">
          <xsl:value-of select="concat('&amp;key=', $key)" />
        </xsl:if>
      </xsl:attribute>
    </img>
  </xsl:template>

  <xsl:template name="google-embedded-map">
    <xsl:param name="address" />
    <xsl:param name="width" />
    <xsl:param name="height" />
    <!-- {mode} is one of 'place', 'directions', 'search', 'view', or 'streetview'. -->
    <xsl:param name="mode" select="'place'" />
    <xsl:param name="zoom" select="15" />
    <xsl:param name="maptype" />
    <xsl:param name="key" select="$GOOGLE_MAPS_API_KEY" />

    <!-- Convert ', ' to just ',' for better accurate query. -->
    <xsl:variable name="escapedAddress">
      <xsl:call-template name="sam-replace-string">
        <xsl:with-param name="text">
          <xsl:call-template name="sam-replace-string">
            <xsl:with-param name="text" select="$address" />
            <xsl:with-param name="replace" select="', '" />
            <xsl:with-param name="with" select="','" />
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="replace" select="' '" />
        <xsl:with-param name="with" select="'+'" />
      </xsl:call-template>
    </xsl:variable>

    <iframe
      width="{$width}"
      height="{$height}"
      frameborder="0" style="border:0" allowfullscreen="">
      <xsl:attribute name="src">
        <xsl:text>https://www.google.com/maps/embed/v1/</xsl:text>
        <xsl:value-of select="$mode" />
        <xsl:value-of select="concat('?key=', $key)" />
        <xsl:choose>
          <xsl:when test="$mode = 'directions'">
            <xsl:value-of select="concat('&amp;destination=', $escapedAddress)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('&amp;q=', $escapedAddress)" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$zoom != ''">
          <xsl:value-of select="concat('&amp;zoom=', $zoom)" />
        </xsl:if>
        <xsl:if test="$maptype != ''">
          <xsl:value-of select="concat('&amp;maptype=', $maptype)" />
        </xsl:if>
        <xsl:text>&amp;attribution_source=</xsl:text>
        <xsl:value-of select="translate($site/@name, ' ', '+')" />
        <xsl:text>&amp;attribution_web_url=</xsl:text>
        <xsl:value-of select="$root-path" />
        <xsl:text>&amp;attribution_ios_deep_link_id=comgooglemaps://?daddr=</xsl:text>
        <xsl:value-of select="$escapedAddress" />
      </xsl:attribute>
    </iframe>
  </xsl:template>
</xsl:stylesheet>
