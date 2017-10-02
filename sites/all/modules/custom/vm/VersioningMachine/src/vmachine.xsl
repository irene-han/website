<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" exclude-result-prefixes="tei"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns="http://www.w3.org/1999/xhtml">
   
   <xsl:output method="html" doctype-system="about:legacy-compat" />

   <!-- <xsl:strip-space elements="*" /> -->
   
   <!-- IMPORT SETTINGS -->
   <xsl:include href="settings.xsl" />

   
   <!-- CREATE VARIABLE FOR EDITION TITLE -->
   <xsl:variable name="fullTitle">
      <xsl:choose>
         <xsl:when test="//tei:titleStmt/tei:title != ''">
            <xsl:value-of select="//tei:titleStmt/tei:title" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>No title specified</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>

   <!-- CREATE VARIABLE FOR WITNESSES/VERSIONS -->
   <xsl:variable name="witnesses" select="//tei:witness[@xml:id]" />

   <xsl:variable name="numWitnesses" select="count($witnesses)" />

   <xsl:variable name="truncatedTitle">
      <xsl:call-template name="truncateText">
         <xsl:with-param name="string" select="$fullTitle" />
         <xsl:with-param name="length" select="40" />
      </xsl:call-template>
   </xsl:variable>

   <xsl:variable name="bothTitles">
      <xsl:for-each select="$witnesses">
         <xsl:variable name="witId"><xsl:value-of select="@xml:id"></xsl:value-of></xsl:variable>
         <xsl:value-of select="//tei:witness[@xml:id = $witId]" />
         <xsl:if test="not(position() = last())"> | </xsl:if>
      </xsl:for-each>
   </xsl:variable>

   <xsl:template match="/">
      <!-- GENERATE BASIC HTML STRUCTURE -->
     <html lang="en">
         <xsl:call-template name="htmlHead" />
        <body class="html not-front page-node">
           <div id="page-wrapper">
              <div id="page">
                  <xsl:call-template name="mainBanner" />
                  <xsl:call-template name="manuscriptArea" />
              </div>
           </div>
           <xsl:if test="$googleAnalyticsCode">
              <script type="text/javascript">
                  <xsl:text disable-output-escaping="yes">
                  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                             (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

                  ga('create', '</xsl:text>
                 <xsl:value-of select="$googleAnalyticsCode" />
                 <xsl:text>', 'auto');
                  ga('send', 'pageview');
                  </xsl:text>
              </script>
           </xsl:if>
         </body>
      </html>
   </xsl:template>
   
   
   <!-- **********START HTML HEAD TEMPLATES************ -->
   
   <xsl:template name="htmlHead">
      <!-- GENERATE HTML HEAD SECTION -->
      <head>
         <title>
            <xsl:value-of select="$truncatedTitle" />
            <xsl:text> | The Global Medieval Sourcebook</xsl:text>
         </title>
         <meta charset="utf-8"/>
         
         
         <!-- JQuery and JQuery UI libraries references -->
         <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
               <xsl:value-of select="$cssJQuery-UI" />
            </xsl:attribute>
         </link>

         <!-- Font Awesome -->
         <script src="https://use.fontawesome.com/b4c1558196.js"></script>


         <!-- include customn CSS -->
         <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
               <xsl:value-of select="$cssInclude" />
            </xsl:attribute>
         </link>


         <!-- include custom font-face -->
         <link href="https://fonts.googleapis.com/css?family=Alegreya|Alegreya+Sans" rel="stylesheet"></link>
        
         <script type="text/javascript">
            <xsl:attribute name="src">
               <xsl:value-of select="$jsJquery" />
            </xsl:attribute>
         </script>
         <script type="text/javascript">
            <xsl:attribute name="src">
               <xsl:value-of select="$jsJquery-UI" />
            </xsl:attribute>
         </script>
         
         
         <!--  image viewer -->
         <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
               <xsl:value-of select="$cssJQueryZoomPan" />
            </xsl:attribute>
         </link>

         <script type="text/javascript">
            <xsl:attribute name="src">
               <xsl:value-of select="$jsJqueryZoomPan" />
            </xsl:attribute>
         </script>
        
        
         <script type="text/javascript">
            <!-- JS to set up global variables -->
            <xsl:call-template name="jsGlobalSettings" />
            <xsl:call-template name="createTimelinePoints" />
            <xsl:call-template name="createTimelineDurations" />
         </script>
         
         <script type="text/javascript">
            <!-- custom JS file has to be added after the Global JS settings-->
            <xsl:attribute name="src">
               <xsl:value-of select="$jsInclude" />
            </xsl:attribute>
         </script>
      </head>
   </xsl:template>
   
   <!-- JAVASCRIPT GLOBAL VARIABLES -->
   <xsl:template name="jsGlobalSettings">
      <!-- INITIAL SETUP: panel display, line numbers, etc. -->
      /*NOTES PANEL: To change the VM so that the notes panel page does not
      appear at the initial load, change the constant INITIAL_DISPLAY_BIB_PANEL from "true" to "false" below */
      INITIAL_DISPLAY_NOTES_PANEL = <xsl:value-of select="$displayNotes"/>;
      
      /*BIB PANEL: To change the VM so that the bibliographic information page does not
      appear at the initial load, change the constant INITIAL_DISPLAY_BIB_PANEL from "true" to "false" below */
      INITIAL_DISPLAY_BIB_PANEL = <xsl:value-of select="$displayBibInfo"/>;
      
      /**The number of version/witness panels to be displayed initially */
      INITIAL_DISPLAY_NUM_VERSIONS = <xsl:value-of select="$displayVersions"/>;
      
      /** CRIT PANEL: Critical information should be encoded as tei:notesStmt/tei:note[@type='critIntro'] in the TEI files -->
      * To change the VM so that the critical information page does not
      * appear at the initial load, change the constant INITIAL_DISPLAY_CRIT_PANEL from "true" to "false" */
      INITIAL_DISPLAY_CRIT_PANEL = <xsl:value-of select="$displayCritInfo"/>;
      
      /** To change the VM so that line numbers are hidden by default, change the constant INITIAL_DISPLAY_LINENUMBERS from
      * "true" to "false" */
      INITIAL_DISPLAY_LINENUMBERS = <xsl:value-of select="$displayLineNumbers"/>;
      
   </xsl:template>
   
   
   <!-- **********END HTML HEAD TEMPLATES************ -->
   
   
   
   
   <!-- **********START MAIN BANNER TEMPLATES************ -->
   
   <xsl:template name="mainBanner">
      <div id="mainBanner">
         <xsl:call-template name="brandingLogo" />
      </div>
      <xsl:call-template name="mainControls" />

   </xsl:template>
   
   <xsl:template name="brandingLogo">
      <div id="brandingLogo">
         <a href="{$logoLink}">
         <img id="home" alt="Return to main site" src="{$drupalLogoPath}"/>
         </a>
      </div>
      <div id="site-name"><a href="{$logoLink}">Global Medieval Sourcebook</a></div>
      <div id="site-slogan">A Digital Repository of Medieval Texts</div>
   </xsl:template>

   <xsl:template name="mainControls">
      <div id="mainControlsWrapper">
         <nav id="mainControls">
            <ul>
               <li><span class="topMenuButton"><a href="{$logoLink}">Home</a></span></li>
               <!-- add version/witness dropdown menu -->
               <xsl:call-template name="versionDropdown"/>

               <!-- add additional nav/control menu -->
               <xsl:call-template name="topMenu"/>
            </ul>
        </nav>
      </div>
   </xsl:template>
   
   <!-- CREATE VERSION/WITNESS DROPDOWN MENU IN NAVIGATION BAR -->
   <xsl:template name="versionDropdown">
      
      <li>
      <span id="selectVersion" class="topMenuButton dropdownButton">
         <xsl:value-of select="count($witnesses)"></xsl:value-of>
         <xsl:text> Versions</xsl:text>
         <img class="noDisplay" src="{$menuArrowUp}" alt="arrow up"/>
         <img src="{$menuArrowDown}" alt="arrow down"/>
      </span>
         <ul>
            <xsl:attribute name="id">versionList</xsl:attribute>
            <xsl:attribute name="class">dropdown notVisible</xsl:attribute>
            <xsl:for-each select="$witnesses">
               <li>
                <xsl:attribute name="data-panelid">
                     <xsl:value-of select="@xml:id"></xsl:value-of>
                 </xsl:attribute>
                  <div>
                       <xsl:attribute name="class">listText</xsl:attribute>

                       <div>
                          <xsl:variable name="witTitle"><xsl:value-of select="@xml:id"/><xsl:text>: </xsl:text><xsl:value-of select="."/></xsl:variable>
                          <a href="#" title="{$witTitle}"><xsl:value-of select="@xml:id"/></a>
                       </div>

                        <div>
                           <span class="toggle">
                              <xsl:text>OFF</xsl:text>
                           </span>
                        </div>
                  </div>
               </li>
            </xsl:for-each>
         </ul>
      </li>
  </xsl:template>
   
  
   <xsl:template name="topMenu">

      <xsl:if test="//tei:l[@n]">
         <li>
            <xsl:attribute name="id">linenumberOnOff</xsl:attribute>
            <xsl:attribute name="title">Clicking this button turns the line numbers on or off.</xsl:attribute>
            <span><xsl:attribute name="class">topMenuButton</xsl:attribute>
                <xsl:text>Line Numbers On</xsl:text>
            </span>
               
         </li>
      </xsl:if>
      <xsl:if test="//tei:notesStmt/tei:note[@type='critIntro']">
         <li>
            <xsl:attribute name="data-panelid">critPanel</xsl:attribute>
            <span>
               <xsl:attribute name="class">topMenuButton listText</xsl:attribute>
               <xsl:attribute name="title">Clicking this button triggers the critical introduction panel to appear or disappear.</xsl:attribute>
               <xsl:text>Introduction</xsl:text>
            </span>
         </li>
      </xsl:if>
         <li>
            <xsl:attribute name="data-panelid">bibPanel</xsl:attribute>
            <xsl:attribute name="title">Clicking this button triggers the bibliographic panel to appear or disappear.</xsl:attribute>
            <span>
               <xsl:attribute name="class">topMenuButton</xsl:attribute>
               <xsl:text>Source Info</xsl:text>
            </span>
         </li>
      <xsl:if test="//tei:body//tei:note">
         <li>
            <xsl:attribute name="data-panelid">notesPanel</xsl:attribute>
            <xsl:attribute name="title">Clicking this button triggers the notes panel to appear or disappear.</xsl:attribute>
            <span>
               <xsl:attribute name="class">topMenuButton listText</xsl:attribute>
               <xsl:text>Notes</xsl:text>
            </span>
         </li>
      </xsl:if>
   </xsl:template>


   <xsl:template name="headline">
      <div id="headline">

         <h1>
            <xsl:value-of select="$bothTitles" />
         </h1>

      </div>
   </xsl:template>
   <!-- **********END MAIN BANNER TEMPLATES************ -->
   
   
   
   
   
   <!-- **********START MANUSCRIPT/TRANSCRIPTION PANEL AREA TEMPLATES************ -->
   
   <xsl:template name="manuscriptArea">

      <div id="mssArea">
         <xsl:call-template name="headline" />

         <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc" />

         <xsl:if test="//tei:witDetail[tei:media[@url]]">
            <!-- Add an audio player if there are audio files encoded -->
            <xsl:call-template name="audioPlayer">
            </xsl:call-template>
         </xsl:if>

         <xsl:for-each select="$witnesses">
               <xsl:call-template name="manuscriptPanel">
                  <xsl:with-param name="witId" select="@xml:id" />
               </xsl:call-template>
            </xsl:for-each>
         <xsl:call-template name="notesPanel" />
         <xsl:choose>
            <xsl:when test="/tei:TEI/tei:facsimile/tei:graphic[@url]">
               <xsl:for-each select="/tei:TEI/tei:facsimile/tei:graphic[@url]">
                <xsl:call-template name="imgViewer" >
                   <xsl:with-param name="imgUrl" select="@url"></xsl:with-param>
                   <xsl:with-param name="imgId" select="@xml:id"/>
                </xsl:call-template>
             </xsl:for-each>
            </xsl:when>
            <xsl:when test="//tei:note[@type='image']//tei:witDetail//tei:graphic[@url]">
               <xsl:for-each select="//tei:note[@type='image']//tei:witDetail//tei:graphic[@url]">
                  <xsl:call-template name="imgViewer" >
                     <xsl:with-param name="imgUrl" select="@url"></xsl:with-param>
                     <xsl:with-param name="imgId" select="@xml:id"/>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:when>
         </xsl:choose>
      </div>
   </xsl:template>
   
   <xsl:template name="manuscriptPanel">
      <xsl:param name="witId" />
      <!-- RB: added draggable resizeable -->
      <div class="ui-widget-content ui-resizable panel mssPanel noDisplay">
         <xsl:attribute name="id">
            <xsl:value-of select="$witId"></xsl:value-of>
         </xsl:attribute>
         <div class="panelBanner">
            <!-- To change the title of the panel banner of each version panel change the text below -->
            
            <xsl:variable name="witTitle"><xsl:text></xsl:text><xsl:value-of select="$witId" /></xsl:variable>
            
            <a title="{$witTitle}"><xsl:value-of select="$witTitle"></xsl:value-of></a>
            <span class="fa fa-times closePanel" title="Close panel"></span>

         </div>
         <div class="mssContent">

            <xsl:if test="//tei:note[@type='image']/tei:witDetail[@target = concat('#',$witId)]//tei:graphic[@url]">
               <!-- Add icons for facsimile images if encoded -->
               <xsl:call-template name="facs-images">
                  <xsl:with-param name="witId" select="$witId"></xsl:with-param>
               </xsl:call-template>
            </xsl:if>

            <xsl:apply-templates select="//tei:front">
               <xsl:with-param name="witId" select="$witId"></xsl:with-param>
            </xsl:apply-templates>
            
            <xsl:apply-templates select="//tei:body">
               <xsl:with-param name="witId" select="$witId"></xsl:with-param>
            </xsl:apply-templates>
            
            <xsl:apply-templates select="//tei:back">
               <xsl:with-param name="witId" select="$witId"></xsl:with-param>
            </xsl:apply-templates>
            
         </div>
      </div>
      
   </xsl:template>

   
   <xsl:template name="audioPlayer">
      <!--<xsl:param name="witId"/>-->
      <!--foreach witness with media-->
      <xsl:for-each select="//tei:witDetail[tei:media[@url]]">
         
         <div>
            <xsl:attribute name="class">audioPlayer <xsl:value-of select="translate(@wit, '#', '')" /></xsl:attribute>
            <xsl:attribute name="data-version"><xsl:value-of select="translate(@wit, '#', '')" /></xsl:attribute>
            <!--<audio controls="controls">-->
            <audio controls="controls" preload="none">
               <!--<xsl:attribute name="id">-->
                  <!--<xsl:value-of select="$witId"/>-->
               <!--</xsl:attribute>-->
               
            <!--foreach source-->
               <xsl:for-each select="//tei:witDetail[tei:media[@url]]/tei:media">
               
               <!--<source>-->
               <!--<xsl:attribute name="src"><xsl:value-of select="@url" /></xsl:attribute>
                           <xsl:attribute name="type"><xsl:value-of select="@mimeType" /></xsl:attribute>-->
               <!--  <span>
                  <xsl:attribute name="class">audioSource</xsl:attribute>
                  <xsl:attribute name="data-src"><xsl:value-of select="@url" /></xsl:attribute>
                  <xsl:attribute name="data-type"><xsl:value-of select="@mimeType" /></xsl:attribute>
                  -->
               <source>
                  <xsl:attribute name="class">audiosource</xsl:attribute>
                  <xsl:attribute name="src"><xsl:value-of select="concat($vmAudioPath, @url)"
                     /></xsl:attribute>
                  <xsl:attribute name="type"><xsl:value-of select="@mimeType" /></xsl:attribute>
               </source>
                  <!-- </span>-->
               <!--</source>-->
               
            </xsl:for-each><!--foreach source-->
               <xsl:text>Your browser does not support the audio element.</xsl:text>
            </audio>
            <!--</audio>-->
         </div>
         
      </xsl:for-each><!--foreach witness with media-->
      
   </xsl:template>
   
   <xsl:template name="facs-images">
      <xsl:param name="witId" />
      <xsl:if test="not(//tei:pb[@facs])">
         <div data-version-id="{$witId}">
               <xsl:attribute name="class">facs-images <xsl:value-of select="$witId"></xsl:value-of></xsl:attribute>
               <xsl:for-each select="//tei:note[@type='image']/tei:witDetail[@target = concat('#',$witId)]//tei:graphic[@url]">
                  <xsl:call-template name="imgLink">
                     <xsl:with-param name="imgUrl" select="@url" />
                     <xsl:with-param name="imgId" select="@xml:id"></xsl:with-param>
                     <xsl:with-param name="wit" select="translate(ancestor::tei:witDetail/@wit,'#','')" />
                  </xsl:call-template>
               </xsl:for-each>
            </div>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:body">
      <xsl:param name="witId"></xsl:param>
      <xsl:apply-templates>
         <xsl:with-param name="witId" select="$witId"></xsl:with-param>
      </xsl:apply-templates>
   </xsl:template>
   
   <xsl:template match="/tei:TEI/tei:teiHeader/tei:fileDesc">
      <div id="bibPanel">
         <xsl:attribute name="class">
            <xsl:text>ui-widget-content ui-resizable panel noDisplay</xsl:text>
         </xsl:attribute>
         <div class="panelBanner">
            Source Information
            <span class="fa fa-times closePanel" title="Close panel"></span>
         </div>
         <div class="bibContent">
            <h2>
               <xsl:value-of select="$bothTitles" />
            </h2>
            <xsl:if test="tei:titleStmt/tei:author">
               <h3>
                  by <xsl:value-of select="tei:titleStmt/tei:author" />
               </h3>
            </xsl:if>
            <xsl:if test="tei:sourceDesc">
               <h4>Original Source</h4>
               <xsl:apply-templates select="tei:sourceDesc" />
            </xsl:if>

            <xsl:if test="tei:titleStmt/tei:respStmt">
               <h5>Responsibility Statement:</h5>
               <ul>
                  <xsl:for-each select="tei:titleStmt/tei:respStmt">
                     <li>
                        <xsl:value-of select="concat(translate(substring(tei:resp,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring(tei:resp,2,string-length(tei:resp)))" />
                        <xsl:for-each select="tei:name | tei:persName | tei:orgName | tei:other">
                           <xsl:text> </xsl:text>
                           <xsl:value-of select="." />
                           <xsl:choose>
                              <xsl:when test="position() = last()"></xsl:when>
                              <xsl:when test="position() = last() - 1">
                                 <xsl:if test="last() &gt; 2">
                                    <xsl:text>,</xsl:text>
                                 </xsl:if>
                                 <xsl:text> and </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>, </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                     </li>
                  </xsl:for-each>
                  <xsl:if test="tei:titleStmt/tei:sponsor">
                     <li>
                        <xsl:text>Sponsored by </xsl:text>
                        <xsl:for-each select="tei:titleStmt/tei:sponsor/tei:orgName | tei:titleStmt/tei:sponsor/tei:persName | tei:titleStmt/tei:sponsor/tei:name | tei:titleStmt/tei:sponsor/tei:other">
                           <xsl:apply-templates select="." />
                           <xsl:choose>
                              <xsl:when test="position() = last()"></xsl:when>
                              <xsl:when test="position() = last() - 1">
                                 <xsl:if test="last() &gt; 2">
                                    <xsl:text>,</xsl:text>
                                 </xsl:if>
                                 <xsl:text> and </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>, </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                     </li>
                  </xsl:if>
                  <xsl:if test="tei:titleStmt/tei:funder">
                     <li>
                        <xsl:text>Funding provided by </xsl:text>
                        <xsl:for-each select="tei:titleStmt/tei:funder/tei:orgName | tei:titleStmt/tei:funder/tei:persName | tei:titleStmt/tei:funder/tei:name | tei:titleStmt/tei:funder/tei:other">
                           <xsl:apply-templates select="." />
                           <xsl:choose>
                              <xsl:when test="position() = last()"></xsl:when>
                              <xsl:when test="position() = last() - 1">
                                 <xsl:if test="last() &gt; 2">
                                    <xsl:text>,</xsl:text>
                                 </xsl:if>
                                 <xsl:text> and </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>, </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                     </li>
                  </xsl:if>
               </ul>
            </xsl:if>
            <xsl:apply-templates select="tei:publicationStmt" />
            <xsl:if test="tei:encodingDesc/tei:editorialDecl">
               <h4>Encoding Principles</h4>
               <xsl:apply-templates select="tei:encodingDesc/tei:editorialDecl" />
            </xsl:if>
            <!--<xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:encodingDesc" />-->
            <xsl:apply-templates select="/tei:TEI/tei:text/tei:front/tei:castList" />
         
         </div>
      </div>
      <xsl:if test="//tei:notesStmt/tei:note[@type='critIntro']">
         <div id="critPanel">
            <xsl:attribute name="class">
               <xsl:text>ui-widget-content ui-resizable panel noDisplay</xsl:text>
            </xsl:attribute>
           
               <div class="panelBanner">
                  Introduction to Text
                  <span class="fa fa-times closePanel" title="Close panel"></span>

               </div>
               <div class="critContent">
                  <h4>Introduction to Text</h4>
                     <xsl:for-each select="//tei:notesStmt">
                        <xsl:apply-templates select="tei:note[@type='critIntro']" />
                     </xsl:for-each>
               </div>
            </div>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:publicationStmt">
      <h5>Publication Details:</h5>
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="tei:publicationStmt/tei:publisher">
      <p>
         <xsl:text>Published by </xsl:text>
         <xsl:apply-templates />
         <xsl:text>.</xsl:text>
      </p>
   </xsl:template>
   
   <xsl:template match="tei:publicationStmt/tei:availability">
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="/tei:TEI/tei:teiHeader/tei:encodingDesc">
      <h4>Encoding Principles</h4>
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:editorialDecl">
      <xsl:apply-templates />
   </xsl:template>

   <xsl:template name="castList" match="tei:front/tei:castList">
      <h4>Cast List</h4>
      <xsl:choose>
         <xsl:when test="./tei:castGroup">
            <div class="castGroup">
               <xsl:copy-of select="text()"></xsl:copy-of>
            </div>
            <xsl:apply-templates />
         </xsl:when>

         <xsl:otherwise>
            <xsl:apply-templates select="tei:castItem"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="castItem" match="tei:castItem">
      <div class="classItem">
         <span class="role">Role: <xsl:value-of select="./tei:role"> </xsl:value-of>
         </span>
         <span class="played-by">Played by: <xsl:value-of select="./tei:actor"> </xsl:value-of>
         </span>
      </div>
   </xsl:template>
   
   <xsl:template match="//tei:encodingDesc/tei:classDecl"></xsl:template>
   
   <xsl:template match="//tei:encodingDesc/tei:tagsDecl"></xsl:template>
   
   <xsl:template match="//tei:encodingDesc/tei:charDecl"></xsl:template>
   
   <xsl:template name="notesPanel">
      <div id="notesPanel">
         <xsl:attribute name="class">
            <xsl:text>ui-widget-content ui-resizable panel noDisplay</xsl:text>
         </xsl:attribute>
         
         <div class="panelBanner">
            Critical Notes
            <span class="fa fa-times closePanel" title="Close panel"></span>

         </div>
         <xsl:for-each select="//tei:body//tei:note[not(@type='image')]">
            <xsl:if test="not(ancestor::tei:note)">
               <div>
                  <xsl:attribute name="class">
                     <xsl:text>noteContent</xsl:text>
                     <xsl:if test="ancestor::*/@wit">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="translate(ancestor::*/@wit,'#','')" />
                     </xsl:if>
                  </xsl:attribute>
                  <xsl:if test="ancestor::*/@wit">
                     <div class="witnesses">
                        <xsl:value-of select="translate(ancestor::*/@wit,'#','')" />
                     </div>
                  </xsl:if>
                  <xsl:choose>
                     <xsl:when test="ancestor::tei:l">
                        <xsl:variable name="lineId">
                           <xsl:text>line_</xsl:text>
                           <xsl:choose>
                              <xsl:when test="ancestor::tei:l[@n]">
                                 <xsl:if test="ancestor::tei:lg[@n]">
                                    <xsl:value-of select="ancestor::tei:lg/@n"></xsl:value-of>
                                    <xsl:text>_</xsl:text>
                                 </xsl:if>
                                 <xsl:value-of select="ancestor::tei:l/@n" />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:for-each select="ancestor::tei:l">
                                    <xsl:value-of select="count(preceding::tei:l)+1"></xsl:value-of>
                                 </xsl:for-each>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <div>
                           <xsl:attribute name="class">
                              <xsl:text>position </xsl:text>
                              <xsl:value-of select="$lineId"/>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="ancestor::tei:l[@n]">
                                 <xsl:text>Line number </xsl:text>
                                 <xsl:value-of select="ancestor::tei:l/@n" />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>Unnumbered line</xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </div>
                     </xsl:when>
                     <xsl:when test="ancestor::tei:p and ancestor::tei:app">
                        
                        <xsl:variable name="appId">
                           <xsl:text>apparatus_</xsl:text>
                           <xsl:choose>
                              <xsl:when test="ancestor::tei:app[@loc]">
                                 <xsl:value-of select="ancestor::tei:app/@loc" />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:for-each select="ancestor::tei:app[1]">
                                    <xsl:value-of select="count(preceding::tei:app)+1"></xsl:value-of>
                                 </xsl:for-each>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <div class="position">
                           <xsl:attribute name="class">
                              <xsl:text>position </xsl:text>
                              <xsl:value-of select="$appId" />
                           </xsl:attribute>
                           Highlight prose section
                        </div>
                     </xsl:when>
                  </xsl:choose>
                  <strong>
                     <xsl:choose>
                        <xsl:when test="@type = 'critical'">
                           <xsl:text>Critical note:</xsl:text>
                        </xsl:when>
                        <xsl:when test="@type = 'biographical'">
                           <xsl:text>Biographical note:</xsl:text>
                        </xsl:when>
                        <xsl:when test="@type = 'physical'">
                           <xsl:text>Physical note:</xsl:text>
                        </xsl:when>
                        <xsl:when test="@type = 'gloss'">
                           <xsl:text>Gloss note:</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>Note:</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:text> </xsl:text>
                  </strong>
                  <xsl:apply-templates />
               </div>
            </xsl:if>
         </xsl:for-each>
         <div id="noNotesFound" class="noteContent">
            Sorry, but there are no notes associated with
            any currently displayed witness.
         </div>
      </div>
   </xsl:template>
   
   <xsl:template match="//tei:body//text()[normalize-space()]">
      <span>
         <xsl:attribute name="class">
            <xsl:value-of select="concat('textcontent ', name(..))" />
         </xsl:attribute>
         <xsl:value-of select="."></xsl:value-of>
      </span>
   </xsl:template>
   
   <xsl:template match="tei:head|tei:epigraph|tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6|tei:div7|tei:div8|tei:lg|tei:ab|tei:sp|tei:stage">
      <xsl:param name="witId"></xsl:param>
     <div>
            <xsl:attribute name="class">
               <xsl:value-of select="name(.)" />
               
               <xsl:if test="@n">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="name(.)" />
                  <xsl:text>-n</xsl:text>
                  <xsl:value-of select="@n" />
               </xsl:if>
               
               <xsl:if test="@type">
                  <xsl:text> </xsl:text>
                  <xsl:text>type-</xsl:text>
                  <xsl:value-of select="@type" />
               </xsl:if>
               
               <xsl:if test="@rend">
                  <xsl:text> </xsl:text>
                  <xsl:text>rend-</xsl:text>
                  <xsl:value-of select="@rend" />
               </xsl:if>
            </xsl:attribute>
            
            <xsl:apply-templates>
               <xsl:with-param name="witId" select="$witId"></xsl:with-param>
            </xsl:apply-templates>
            
         </div>
   </xsl:template>

   <xsl:template name="imgLink">
      <xsl:param name="imgUrl" />
      <xsl:param name="wit" />
      <xsl:param name="imgId"/>
      
      <xsl:if test="$imgUrl != ''">
         <img src="{$facsImageFolder}{$imgUrl}" alt="Facsimile Image" title="Open the image viewer">
            <xsl:attribute name="class">
               <xsl:text>imgLink</xsl:text>
               <xsl:if test="$wit != ''">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$wit" />
               </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="data-version-id">
               <xsl:if test="$wit != ''">
                  <xsl:value-of select="$wit" />
               </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="data-img-url">
               <xsl:value-of select="$imgUrl" />
            </xsl:attribute>
            <xsl:attribute name="data-img-id">
            <xsl:choose>
               <xsl:when test="$imgId">
                  <xsl:value-of select="$imgId" />
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="translate(translate($imgUrl,'/','-'),'.','-')" />
               </xsl:otherwise>
            </xsl:choose>
            </xsl:attribute>
         </img>
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:fw" />
   
   <xsl:template match="tei:note[@type='critIntro']//tei:l">
      <div class="line">
         <xsl:apply-templates></xsl:apply-templates>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:l">
      <xsl:param name="witId"></xsl:param>
      
      <xsl:if test="text()[normalize-space(.)!=''] or descendant::node()[contains(@wit, $witId)]">
      
      <xsl:variable name="lineId">
         <xsl:text>line_</xsl:text>
         <xsl:choose>
            <xsl:when test="@n">
               <xsl:if test="parent::tei:lg[@n]">
                  <xsl:value-of select="parent::tei:lg/@n"></xsl:value-of>
                  <xsl:text>_</xsl:text>
               </xsl:if>
               <xsl:value-of select="@n" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="count(preceding::tei:l)+1"></xsl:value-of>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- lineWrapper is necessary for the correct line highlighting -->
      <div class="lineWrapper {$lineId}" data-line-id="{$lineId}">
         <!-- here starts the actual line div -->
         <div>
           <xsl:attribute name="class">
              <xsl:text>line</xsl:text>
              <xsl:if test="not(descendant::tei:rdg) or not(descendant::tei:app)">
              <xsl:for-each select="$witnesses">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="@xml:id"></xsl:value-of>
               </xsl:for-each>
              </xsl:if>
           </xsl:attribute>

            <xsl:if test="@n">
               <div class="linenumber noDisplay">
                  <xsl:if test="@n mod 5 = 0">
                     <xsl:value-of select="@n" />
                  </xsl:if>
               </div>
            </xsl:if>
            <xsl:apply-templates>
               <xsl:with-param name="witId" select="$witId"></xsl:with-param>
            </xsl:apply-templates>
         </div>
      </div>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:hi">
      <xsl:param name="witId"></xsl:param>
      <span>
         <xsl:attribute name="class">
            <xsl:text>hi</xsl:text>
            <xsl:if test="@rend">
               <xsl:text> rend-</xsl:text>
               <xsl:value-of select="@rend" />
            </xsl:if>
         </xsl:attribute>
         <xsl:apply-templates >
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>
      </span>
   </xsl:template>
   
   <xsl:template match="tei:del">
      <xsl:param name="witId"></xsl:param>
      <del>
         <xsl:if test="@rend">
            <xsl:attribute name="class">
               <xsl:value-of select="name(.)"></xsl:value-of>
               <xsl:text> rend-</xsl:text>
               <xsl:value-of select="@rend" />
            </xsl:attribute>
         </xsl:if>
         <xsl:apply-templates >
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>
      </del>
   </xsl:template>
   
   <xsl:template match="tei:add">
      <xsl:param name="witId"></xsl:param>
      <ins>
            <xsl:attribute name="class">
               <xsl:value-of select="name(.)"></xsl:value-of>
               <xsl:if test="@rend">
                  <xsl:text> rend-</xsl:text>
                  <xsl:value-of select="@rend" />
               </xsl:if>
               <xsl:if test="@rend and @place">
                  <xsl:text> </xsl:text>
               </xsl:if>
               <xsl:if test="@place">
                  <xsl:text>place-</xsl:text>
                  <xsl:value-of select="@place" />
               </xsl:if>
            </xsl:attribute>
         <xsl:apply-templates>
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>
      </ins>
   </xsl:template>
   
   <xsl:template match="tei:unclear">
      <xsl:param name="witId"></xsl:param>
      <span class="unclear">
         <xsl:apply-templates>
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>
      </span>
   </xsl:template>
   
   <xsl:template match="tei:lb">
      <div class="linebreak"></div>
   </xsl:template>
   
   <xsl:template match="tei:pb">
      <hr>
         <xsl:attribute name="class">
            <xsl:text>pagebreak</xsl:text>
            <xsl:if test="@ed">
               <xsl:text> </xsl:text>
               <xsl:value-of select="translate(@ed,'#','')" />
            </xsl:if>
         </xsl:attribute>
         <xsl:if test="@ed">
            <xsl:attribute name="data-version-id">
               <xsl:value-of select="translate(@ed,'#','')" />
            </xsl:attribute>
         </xsl:if>
      </hr>
         <xsl:if test="@facs">
            <xsl:variable name="imgId">
               <xsl:value-of select="translate(@facs,'#','')" />
            </xsl:variable>
            <div>
               <xsl:attribute name="class">facs-images
                  <xsl:if test="@ed">
                     <xsl:text> </xsl:text>
                     <xsl:value-of select="translate(@ed,'#','')" />
                  </xsl:if>
               </xsl:attribute>
               <xsl:if test="@ed">
                  <xsl:attribute name="data-version-id">
                     <xsl:value-of select="translate(@ed,'#','')" />
                  </xsl:attribute>
               </xsl:if>
            <xsl:call-template name="imgLink">
               <xsl:with-param name="imgId" select="$imgId"/>
               <xsl:with-param name="imgUrl">
                  <xsl:choose>
                     <xsl:when test="contains(@facs,'#')">
                        <xsl:if test="//tei:graphic[@xml:id = $imgId]/@url">
                           <xsl:value-of select="//tei:graphic[@xml:id = $imgId]/@url" />
                        </xsl:if>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="@facs" />
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:with-param>
               <xsl:with-param name="wit">
                  <xsl:choose>
                     <xsl:when test="@ed">
                        <xsl:value-of select="translate(@ed,'#','')" />
                     </xsl:when>
                     <xsl:when test="ancestor::*/@wit">
                        <xsl:value-of select="translate(ancestor::*/@wit,'#','')" />
                     </xsl:when>
                  </xsl:choose>
               </xsl:with-param>
            </xsl:call-template>
            </div>
         </xsl:if>
      
   </xsl:template>
   
   
   <xsl:template match="tei:p|tei:u">
      <xsl:param name="witId"></xsl:param>
      <!-- We cannot use the HTML <p>...</p> element here because of the
      different qualities of a TEI <p> and an HTML <p>. For example,
      TEI allows certain objects to be nested within a paragraph (like
      <table>...</table>) that HTML does not -->
      <xsl:choose>
         <xsl:when test="ancestor::tei:note or ancestor::tei:fileDesc or ancestor::tei:encodingDesc or tei:notesStmt">
            <p><xsl:apply-templates>
               <xsl:with-param name="witId" select="$witId"></xsl:with-param>
            </xsl:apply-templates></p>
         </xsl:when>
         <xsl:otherwise>
            <div class="paragraph">
               <!-- Number every paragraph, but only in the body -->
               <xsl:if test="ancestor::tei:body and (count(//tei:body/*/tei:p) > 1)">
                  <xsl:number />
               </xsl:if>
               <xsl:apply-templates>
                  <xsl:with-param name="witId" select="$witId"></xsl:with-param>
               </xsl:apply-templates>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   
   <xsl:template match="tei:milestone[@unit = 'stanza']">
      <div>
         <xsl:attribute name="class">
            <xsl:text>stanzabreak</xsl:text>
            <xsl:if test="@ed">
               <xsl:text> </xsl:text>
               <xsl:value-of select="translate(@ed,'#','')" />
            </xsl:if>
         </xsl:attribute>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:table">
      <xsl:param name="witId"></xsl:param>
      <table class="mssTable">
         <xsl:apply-templates>
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>
      </table>
   </xsl:template>
   
   <xsl:template match="tei:table/tei:row">
      <xsl:param name="witId"></xsl:param>
      <tr>
         <xsl:apply-templates>
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>
      </tr>
   </xsl:template>
   
   <xsl:template match="tei:table/tei:row/tei:cell">
      <xsl:param name="witId"></xsl:param>
      <td>
         <xsl:apply-templates>
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>
      </td>
   </xsl:template>
   
   <xsl:template match="tei:rdgGrp">
      <xsl:param name="witId"></xsl:param>
      <xsl:choose>
         <xsl:when test="count(tei:rdg) &gt; 1">
            <div>
               <xsl:attribute name="class">
                  <xsl:text>rdgGrp</xsl:text>

               </xsl:attribute>
               <xsl:value-of select="tei:rdg[position() = 1]" />
               <div class="altRdg">
                  <xsl:for-each select="tei:rdg[position() &gt; 1]">
                     <xsl:apply-templates>
                        <xsl:with-param name="witId" select="$witId"></xsl:with-param>
                     </xsl:apply-templates>
                     <xsl:if test="position() != last()">
                        <hr />
                     </xsl:if>
                  </xsl:for-each>
               </div>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates>
               <xsl:with-param name="witId" select="$witId"></xsl:with-param>
            </xsl:apply-templates>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:space[@unit='chars']">
      <xsl:variable name="quantity">
         <xsl:choose>
            <xsl:when test="@quantity">
               <xsl:value-of select="@quantity" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="1" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="whiteSpace">
         <xsl:with-param name="iteration" select="1" />
         <xsl:with-param name="quantity" select="$quantity" />
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template name="whiteSpace">
      <xsl:param name="iteration" />
      <xsl:param name="quantity" />
      <xsl:text>&#xa0;</xsl:text>
      <xsl:if test="$iteration &lt; $quantity">
         <xsl:call-template name="whiteSpace">
            <xsl:with-param name="iteration" select="$iteration + 1" />
            <xsl:with-param name="quantity" select="$quantity" />
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:note[not(@type='critIntro')]">
      <div class="noteicon">
         <xsl:choose>
            <xsl:when test="@type = 'critical'">
               <xsl:text>c</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'biographical'">
               <xsl:text>b</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'physical'">
               <xsl:text>p</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'gloss'">
               <xsl:text>g</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>n</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
         <div class="note">
            <strong>
               <xsl:choose>
                  <xsl:when test="@type = 'critical'">
                     <xsl:text>Critical note:</xsl:text>
                  </xsl:when>
                  <xsl:when test="@type = 'biographical'">
                     <xsl:text>Biographical note:</xsl:text>
                  </xsl:when>
                  <xsl:when test="@type = 'physical'">
                     <xsl:text>Physical note:</xsl:text>
                  </xsl:when>
                  <xsl:when test="@type = 'gloss'">
                     <xsl:text>Gloss note:</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>Note:</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </strong>
            <xsl:text> </xsl:text>
            <xsl:apply-templates />
         </div>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:note//tei:note">
      <br />
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="tei:figure"></xsl:template>
   
   
   <xsl:template match="tei:app">
      <xsl:param name="witId"></xsl:param>
      <xsl:variable name="selfNode" select="current()"></xsl:variable>
      <xsl:variable name="appId">
         <!-- loc ID for apparatus: important for highlighting of app and location based referencing -->
         <xsl:text>apparatus_</xsl:text>
         <xsl:choose>
            <xsl:when test="@loc">
               <xsl:value-of select="@loc"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="count(preceding::tei:app)+1"></xsl:value-of>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <div>
            <xsl:for-each select="*">
               <xsl:if test="contains(@wit, $witId)">
                  <xsl:attribute name="style">
                     <xsl:text>display:inline-block</xsl:text>
                  </xsl:attribute>
               </xsl:if>
            </xsl:for-each>
         
         <xsl:attribute name="class">
            <xsl:text>apparatus </xsl:text>
            <xsl:value-of select="$appId"></xsl:value-of>
         </xsl:attribute>
         <xsl:attribute name="data-app-id">
            <xsl:value-of select="$appId"></xsl:value-of>
         </xsl:attribute>
         <xsl:apply-templates>
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>
      </div>
   </xsl:template>
   
   <xsl:template name="string-replace-all">
      <!-- found on http://geekswithblogs.net/Erik/archive/2008/04/01/120915.aspx -->
      <xsl:param name="text" />
      <xsl:param name="replace" />
      <xsl:param name="by" />
      <xsl:choose>
         <xsl:when test="contains($text, $replace)">
            <xsl:value-of select="substring-before($text,$replace)" />
            <xsl:value-of select="$by" />
            <xsl:call-template name="string-replace-all">
               <xsl:with-param name="text"
                  select="substring-after($text,$replace)" />
               <xsl:with-param name="replace" select="$replace" />
               <xsl:with-param name="by" select="$by" />
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$text" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:rdg|tei:lem">
      <xsl:param name="witId"></xsl:param>
      <xsl:variable name="readings">
         <xsl:choose>
            <xsl:when test="//tei:listWit[@xml:id]">
               <xsl:choose>
                  <xsl:when test="contains(@wit, //tei:listWit/@xml:id)">
                     <xsl:for-each select="//tei:listWit[@xml:id]/tei:witness">
                        <xsl:value-of select="@xml:id"></xsl:value-of>
                        <xsl:text> </xsl:text>
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="@wit"></xsl:with-param>
                        <xsl:with-param name="replace"><xsl:text>#</xsl:text></xsl:with-param>
                        <xsl:with-param name="by"><xsl:text></xsl:text></xsl:with-param>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="string-replace-all">
                  <xsl:with-param name="text" select="@wit"></xsl:with-param>
                  <xsl:with-param name="replace"><xsl:text>#</xsl:text></xsl:with-param>
                  <xsl:with-param name="by"><xsl:text></xsl:text></xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="currentWitId" select="@wit"/>
      <div>
         
         <xsl:if test="contains(@wit, $witId)">
            <xsl:attribute name="style">
            <xsl:text>display:inline-block</xsl:text>
            </xsl:attribute>
         </xsl:if>
            <xsl:attribute name="class">reading <xsl:value-of select="$readings"></xsl:value-of>
               <xsl:if test="tei:timeline/tei:when">
                  <xsl:text> audioReading</xsl:text>
               </xsl:if>
               <xsl:if test="not(*) and not(normalize-space())">
                  <xsl:text> emptyReading</xsl:text>
               </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="data-reading-wits"><xsl:value-of select="$readings"></xsl:value-of></xsl:attribute>
            
            
            <xsl:if test="tei:timeline/tei:when">
               <xsl:for-each select="tei:timeline/tei:when">
                  <xsl:if test="@since">
                     <xsl:attribute name="data-timeline">
                        <xsl:value-of select="translate(@since,'#','')" />
                     </xsl:attribute> 
                  </xsl:if>  
               </xsl:for-each>
               <xsl:if test="tei:timeline[@unit='s']">
                  
                  <xsl:attribute name="data-timeline-start">
                     <xsl:choose>
                        <xsl:when test="tei:when/@since">
                           <xsl:text>0</xsl:text> 
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="sum(preceding::tei:rdg[@wit=$currentWitId]/tei:timeline/tei:when/@interval)"/>
                        </xsl:otherwise>
                     </xsl:choose> 
                  </xsl:attribute>
                  
                  <xsl:attribute name="data-timeline-interval">
                     <xsl:value-of select="tei:timeline/tei:when/@interval" />
                  </xsl:attribute>
               </xsl:if>
            </xsl:if>
            <xsl:apply-templates>
               <xsl:with-param name="witId" select="$witId"></xsl:with-param>
            </xsl:apply-templates>   
         </div>
      
   </xsl:template>
 
   <xsl:template match="tei:choice">
      <xsl:param name="witId"></xsl:param>
      <xsl:choose>
         <xsl:when test="tei:sic and tei:corr">
            <xsl:call-template name="displayChoice">
               <xsl:with-param name="inline" select="tei:sic" />
               <xsl:with-param name="hover" select="tei:corr" />
               <xsl:with-param name="label" select="'Correction:'" />
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="tei:orig and tei:reg">            
            <xsl:call-template name="displayChoice">
               <xsl:with-param name="inline" select="tei:orig" />
               <xsl:with-param name="hover" select="tei:reg" />
               <xsl:with-param name="label" select="'Regularized form:'" />
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="tei:abbr and tei:expan">
            <xsl:call-template name="displayChoice">
               <xsl:with-param name="inline" select="tei:abbr" />
               <xsl:with-param name="hover" select="tei:expan" />
               <xsl:with-param name="label" select="'Expanded abbreviation:'" />
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="count(*) &gt;= 2">
            <xsl:call-template name="displayChoice">
               <xsl:with-param name="inline" select="*[1]" />
               <xsl:with-param name="hover" select="*[2]" />
               <xsl:with-param name="label" select="''" />
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>            
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="displayChoice">
      <xsl:param name="inline" />
      <xsl:param name="hover" />
      <xsl:param name="label" />
      <div class="choice">
         <xsl:apply-templates select="$inline" />
         <div class="corr">
            <div class="interior">
               <xsl:if test="$label != ''">
                  <strong><xsl:value-of select="$label" /></strong>
                  <xsl:text> </xsl:text>
               </xsl:if>
               <xsl:apply-templates select="$hover" />
            </div>
         </div>
      </div>
   </xsl:template>
   
   <xsl:template name="imgViewer">
      <xsl:param name="imgId"></xsl:param>
      <xsl:param name="imgUrl"></xsl:param>
      <div class="draggable resizable ui-resizable panel imgPanel noDisplay">
         <xsl:attribute name="id">
            <xsl:choose>
               <xsl:when test="$imgId">
                  <xsl:value-of select="$imgId" />
               </xsl:when>
               <xsl:otherwise><xsl:value-of select="translate(translate($imgUrl,'/','-'),'.','-')" /></xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <div title="Click to drag panel." class="viewerHandle handle_imgViewer">
            <span class="viewerHandleLt title_imgViewer">
               <xsl:choose>
                  <xsl:when test="string-length($imgUrl)>30">
                     <xsl:variable name="strgLength-29" select="string-length($imgUrl) - 29"></xsl:variable>
                     <a title="{$imgUrl}"><xsl:text>...</xsl:text><xsl:value-of select="substring($imgUrl,$strgLength-29,30)"/></a>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$imgUrl"></xsl:value-of>
                  </xsl:otherwise>
               </xsl:choose>
            </span>
            <span class="fa fa-times viewerHandleRt closePanel" title="Close panel"></span>
         </div>
         <div class="viewerContent" id="content_imgViewer">

            
               <div class="panzoom-parent" style="overflow:visible">
            <!-- panzoom image -->
            <div class="panzoom">
                     <img width="300" border="1px 2px, 2px, 1px solid #000;" alt="image">
                        <xsl:attribute name="src">
                           <xsl:value-of select="$facsImageFolder"/>
                           <xsl:value-of select="$imgUrl" />
                        </xsl:attribute>
                        
                     </img>
                  </div>
                 
               </div><!-- zoom parent end -->
            <!-- zoom control -->
            <div class="buttons">
               <button class="zoom-out">-</button>
               <input type="range" min="0" max="100" class="zoom-range"/>
               <button class="zoom-in">+</button>
               
            </div>
            <!-- End implementation of image viewer -->
         </div>
         
      </div>
   </xsl:template>
   
   <xsl:template name="truncateText">
      <xsl:param name="string"/>
      <xsl:param name="length"/>
      <xsl:choose>
         <xsl:when test="string-length($string) &gt; $length">
            <xsl:value-of select="concat(substring($string,1,$length),'...')" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$string" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:ref">
      <a class="link">
         <xsl:attribute name="href">
            <xsl:value-of select="@target"/>
         </xsl:attribute>
         <xsl:value-of select="." />
      </a>
   </xsl:template>
   
  <xsl:template match="tei:closer|tei:closer|tei:salute|tei:signed">
     <xsl:param name="witId"></xsl:param>
      <div>    
         <xsl:attribute name="class">
            <xsl:value-of select="name(.)" />
         </xsl:attribute>
         <xsl:apply-templates>
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>         
      </div>
   </xsl:template>
     
   <xsl:template match="tei:head[(@type='section')]">
      <xsl:param name="witId"></xsl:param>
      <div class="section">
         
         <xsl:apply-templates>
            <xsl:with-param name="witId" select="$witId"></xsl:with-param>
         </xsl:apply-templates>
         
      </div>
      
   </xsl:template>

   <xsl:template name="createTimelinePoints">   
        
        <xsl:text>var timelinePoints = new Array();</xsl:text>
        
        <xsl:for-each select="//tei:when">
            <xsl:choose>
                <xsl:when test="not(@since)">
                  <xsl:text>&#x0a;timelinePoints['</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>']=</xsl:text><xsl:choose><xsl:when test="@absolute"><xsl:value-of select="@absolute"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose><xsl:text>;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#x0a;timelinePoints['</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>']=</xsl:text><xsl:call-template name="calculateTimeOffset"><xsl:with-param name="when" select="."/><xsl:with-param name="offsetSoFar" select="0"/></xsl:call-template><xsl:text>;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="calculateTimeOffset">
        <xsl:param name="when"/>
        <xsl:param name="offsetSoFar"/>
        <xsl:choose>
            <xsl:when test="$when/@since">
                <xsl:variable name="prevId" select="substring-after($when/@since, '#')"/>
                <xsl:call-template name="calculateTimeOffset">
                    <xsl:with-param name="when" select="//tei:when[@xml:id=$prevId]"/>
                    <xsl:with-param name="offsetSoFar" select="$offsetSoFar + $when/@interval"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$offsetSoFar"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

   <xsl:template name="createTimelineDurations">   

        <xsl:text>var timelineDurations = new Array();</xsl:text>    
      
         <xsl:for-each select="//tei:when">
            <xsl:choose>
              <xsl:when test="not(@since)">
                <xsl:text>&#x0a;timelineDurations['</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>']=0;</xsl:text>
              </xsl:when>
                <xsl:otherwise>
                     <xsl:text>&#x0a;timelineDurations['</xsl:text><xsl:value-of select="translate(@since,'#','')" /><xsl:text>']=</xsl:text><xsl:value-of select="@interval"/><xsl:text>;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>
