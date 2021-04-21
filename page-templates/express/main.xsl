<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="xlink">

  <xsl:import href="./buckets.xsl"/>
  <xsl:import href="./chunks.xsl" />
  <xsl:import href="./bios.xsl"/>

  <xsl:variable name="CONTENT-GROUPS" select="'Section'" />

  <!-- Main content on normal pages. It has a name so it can be called. -->
  <xsl:template name="main-content">
    <xsl:param name="except" select="''"/>

    <!-- This will try to match all the chunks that start a bucket. -->
    <xsl:apply-templates
      select="chunk[
        meta[@name = 'Content-Group']/value != 'Footer'
        and ($except = '' or not(contains($except, meta[@name = 'Content-Group']/value)))
        and not(
          meta[@name='Content-Group']/value = preceding-sibling::chunk[1]/meta[@name='Content-Group']/value
        )
      ]"
      mode="bucket-grouping" >
      <xsl:with-param name="style_formats" select="'.style-formats'" />
      <xsl:sort select="@sequence" order="ascending" data-type="number" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="/SAM/page" mode="main-content">
    <xsl:attribute name="class">page-container main</xsl:attribute>
    <xsl:call-template name="main-content">
    </xsl:call-template>
  </xsl:template>

  <!--
  A wrapper to pass the chunks in this bucket group as parameter.
  This template is applied per first chunk starting a bucket group.
  -->
  <xsl:template match="chunk" mode="bucket-grouping">
    <xsl:variable name="compare-value" select="meta[@name = 'Content-Group']/value" />
    <xsl:variable name="next-groups" select="./following-sibling::chunk[meta[@name = 'Content-Group']/value != $compare-value]" />
    <xsl:variable name="ns2" select="$next-groups[1]/preceding-sibling::chunk" />
    <!-- Kayessian XPath 1.0 formula for node-set intersection: $ns1[count(.|$ns2) = count($ns2)] -->
    <xsl:variable name="chunks-in-this-group" select=".|following-sibling::chunk[
      count($next-groups) = 0 or (count(.|$ns2) = count($ns2))
    ]" />

    <xsl:apply-templates select="." mode="bucket">
      <xsl:with-param name="siblings" select="$chunks-in-this-group"/>
      <xsl:with-param name="style_formats" select="'.style-formats'" />
    </xsl:apply-templates>
  </xsl:template>


  <!--
  A wrapper to pass the chunks in this bucket group as parameter.
  This template is applied per first chunk starting a bucket group.
  -->
  <xsl:template match="chunk[meta[@name = 'Content-Group']/value = 'Inline']" mode="bucket-grouping">
    <xsl:variable name="compare-value" select="meta[@name = 'Content-Group']/value" />
    <xsl:variable name="next-groups" select="./following-sibling::chunk[meta[@name = 'Content-Group']/value != $compare-value]" />
    <xsl:variable name="ns2" select="$next-groups[1]/preceding-sibling::chunk" />
    <!-- Kayessian XPath 1.0 formula for node-set intersection: $ns1[count(.|$ns2) = count($ns2)] -->
    <xsl:variable name="chunks-in-this-group" select=".|following-sibling::chunk[
      count($next-groups) = 0 or (count(.|$ns2) = count($ns2))
    ]" />

    <!-- <xsl:apply-templates select="." mode="bucket">
      <xsl:with-param name="siblings" select="$chunks-in-this-group"/>
    </xsl:apply-templates> -->

    <section class="inline padded">
      <div class="container w-container">
        <xsl:apply-templates select="
        .|$chunks-in-this-group[
          not(
            chunkData/@type = preceding-sibling::chunk[1]/chunkData/@type
            or (chunkData = false() and preceding-sibling::chunk[1]/chunkData = false())
          )
        ]" mode="chunk-grouping">
          <xsl:with-param name="siblings" select="$chunks-in-this-group"/>
          <xsl:with-param name="style_formats" select="'#style-formats'" />
        </xsl:apply-templates>
      </div>
    </section>
  </xsl:template>

</xsl:stylesheet>
