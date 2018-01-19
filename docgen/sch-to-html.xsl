<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                xmlns:f="#"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/sch:schema">
        <html>
            <head>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
                <title><xsl:value-of select="sch:title"/></title>
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"/>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/default.min.css" integrity="sha256-Zd1icfZ72UBmsId/mUcagrmN7IN5Qkrvh75ICHIQVTk=" crossorigin="anonymous" />
            </head>
            <body class="container">
                <h1><xsl:value-of select="sch:title"/></h1>
                <xsl:apply-templates select="sch:pattern"/>
                <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous">&#xA0;</script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous">&#xA0;</script>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous">&#xA0;</script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js" integrity="sha256-/BfiIkHlHoVihZdc6TFuj7MmJ0TWcWsMXkeDFwhi0zw=" crossorigin="anonymous">&#xA0;</script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/languages/xml.min.js" integrity="sha256-tTizFdjdqBNNTjhOdrSB4jSoCiSZjbtQBdsUSl+P+PQ=" crossorigin="anonymous">&#xA0;</script>
                <script>hljs.initHighlightingOnLoad();</script>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="sch:pattern">
        <section>
            <h2><xsl:value-of select="(sch:p[tokenize(@class,'\s+') = 'title'], @id)[1]"/></h2>
            <xsl:for-each select="sch:p[not(tokenize(@class,'\s+') = 'title')]">
                <p><xsl:value-of select="."/></p>
            </xsl:for-each>
            <xsl:for-each select="sch:rule">
                <xsl:variable name="id" select="if (parent::*/@id) then concat('code_',parent::*/@id,'_',count(preceding-sibling::sch:rule)+1) else generate-id(.)"/>
                <p><a class="btn btn-secondary btn-sm" data-toggle="collapse" href="#{$id}" role="button" aria-expanded="false" aria-controls="{$id}">Show/hide code for <code><xsl:value-of select="@context"/></code></a></p>
                <pre id="{$id}" class="collapse" xml:space="preserve"><code class="hljs xml"><xsl:apply-templates select="." mode="copy"/></code></pre>
            </xsl:for-each>
            <hr/>
        </section>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="copy">
        <!-- generates an escaped and pretty-printed representation of an XML element -->
        <xsl:param name="indent" select="0" as="xs:integer"/>
        <xsl:variable name="one-indent" select="'  '"/>
        <xsl:variable name="indent-string" select="string-join(for $i in (1 to $indent) return $one-indent,'')"/>
        <xsl:variable name="preserve-space" select="(ancestor-or-self::*[@xml:space])[1]/@xml:space = 'preserve'"/>
        <xsl:choose>
            <xsl:when test="self::*">
                <xsl:if test="not($preserve-space) and $indent gt 0">
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:value-of select="$indent-string"/>
                </xsl:if>
                <xsl:text>&lt;</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:for-each select="@*">
                    <xsl:sort select="name()"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="name()"/>
                    <xsl:text>="</xsl:text>
                    <xsl:copy-of select="f:escape-xml(., '&quot;')"/>
                    <xsl:text>"</xsl:text>
                </xsl:for-each>
                <xsl:choose>
                    <xsl:when test="node()">
                        <xsl:text>&gt;</xsl:text>
                        <xsl:apply-templates select="node()" mode="#current">
                            <xsl:with-param name="indent" select="$indent + 1"/>
                        </xsl:apply-templates>
                        <xsl:if test="not($preserve-space)">
                            <xsl:text>&#xA;</xsl:text>
                            <xsl:value-of select="$indent-string"/>
                        </xsl:if>
                        <xsl:text>&lt;/</xsl:text>
                        <xsl:value-of select="name()"/>
                        <xsl:text>&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>/&gt;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="self::text()">
                <xsl:choose>
                    <xsl:when test="$preserve-space">
                        <xsl:copy-of select="f:escape-xml(., '')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#xA;</xsl:text>
                        <xsl:value-of select="$indent-string"/>
                        <xsl:value-of select="f:escape-xml(normalize-space(.), '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>No rule:</xsl:text>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:function name="f:escape-xml" as="xs:string">
        <xsl:param name="text" as="xs:string"/>
        <xsl:param name="inside-quote" as="xs:string"/>
        
        <xsl:variable name="escaped" select="replace(replace(replace($text, '&amp;', '&amp;amp;'),
                                                                            '&lt;', '&amp;lt;'),
                                                                            '&gt;', '&amp;gt;')"/>
        <xsl:variable name="escaped" select="if ($inside-quote = '&quot;') then replace($escaped, '&quot;', '&amp;quot;') else $escaped"/>
        <xsl:variable name="escaped" select="if ($inside-quote = '''') then replace($escaped, '''', '&amp;apos;') else $escaped"/>
        <xsl:value-of select="$escaped"/>
    </xsl:function>
    
</xsl:stylesheet>