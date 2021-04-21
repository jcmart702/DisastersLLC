<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="buckets.xsl" />
  <xsl:import href="chunk-entities.xsl" />

  <xsl:variable name="CONTENT-GROUPS">
    <xsl:text>Marquee, Two Column, Three Column, Inline, Full Width, Notice</xsl:text>
    <xsl:if test="/SAM/page/@id = $home-id">, Footer</xsl:if>
  </xsl:variable>

  <xsl:template match="SAM/page" mode="main-content">
    <xsl:param name="except" select="''"/>

    <xsl:variable name="href-override" select="./navigation/breadcrumb[position() = last()]/href-override" />

    <xsl:if test="/SAM/@directive = 'admin' and $href-override != ''">
      <div class="container">
        <p style="text-align:center;color:red">
          <xsl:text>This page is being overriden to:</xsl:text>
          <br/>
          <a style="color: #151F6D;" href="{$href-override}" target="_blank">
            <xsl:value-of select="$href-override" />
          </a>.
          <br/>
          <xsl:text>You may change this in Page &gt; Edit Info &gt; Manual URL Override.</xsl:text>
        </p>
      </div>
    </xsl:if>

    <!-- This will try to match all the chunks that start a bucket. -->
    <xsl:apply-templates
      select="chunk[
        (meta[@name = 'Content-Group']/value != 'Footer'
        and meta[@name = 'Content-Group']/value != 'Notice')
        and ($except = '' or not(contains($except, meta[@name = 'Content-Group']/value)))
        and not(
          meta[@name='Content-Group']/value = preceding-sibling::chunk[1]/meta[@name='Content-Group']/value
        )
      ]"
      mode="bucket-wrapper" >
      <xsl:sort select="@sequence" order="ascending" data-type="number" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="chunk" mode="bucket-wrapper">
    <xsl:param name="class" />
    <xsl:variable name="bucket" select="./meta[@name = 'Content-Group']/value" />
    <xsl:variable name="next-groups" select="./following-sibling::chunk[meta[@name = 'Content-Group']/value != $bucket]" />
    <xsl:variable name="ns2" select="$next-groups[1]/preceding-sibling::chunk" />
    <!-- Kayessian XPath 1.0 formula for node-set intersection: $ns1[count(.|$ns2) = count($ns2)] -->
    <xsl:variable name="chunks" select=".|following-sibling::chunk[
      count($next-groups) = 0 or (count(.|$ns2) = count($ns2))
    ]" />

    <xsl:apply-templates select="." mode="bucket">
      <xsl:with-param name="chunks" select="$chunks" />
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>
