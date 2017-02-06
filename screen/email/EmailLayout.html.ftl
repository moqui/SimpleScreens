<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <#-- Based on MailChimp Email Blueprints https://github.com/mailchimp/email-blueprints -->
    <#-- fields used: subject, preHeaderContent, headerImageUrl, bodyContent (required), fromName, footerContent -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>${subject}</title>
    <style type="text/css">
        <#-- CLIENT-SPECIFIC STYLES -->
        #outlook a{padding:0;} <#-- Force Outlook to provide a "view in browser" message -->
        .ReadMsgBody{width:100%;} .ExternalClass{width:100%;} <#-- Force Hotmail to display emails at full width -->
        .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height: 100%;} <#-- Force Hotmail to display normal line spacing -->
        body, table, td, p, a, li, blockquote{-webkit-text-size-adjust:100%; -ms-text-size-adjust:100%;} <#-- Prevent WebKit and Windows mobile changing default text sizes -->
        table, td{mso-table-lspace:0pt; mso-table-rspace:0pt;} <#-- Remove spacing between tables in Outlook 2007 and up -->
        img{-ms-interpolation-mode:bicubic;} <#-- Allow smoother rendering of resized image in Internet Explorer -->
        <#-- RESET STYLES -->
        body{margin:0; padding:0;}
        img{border:0; height:auto; line-height:100%; outline:none; text-decoration:none;}
        table{border-collapse:collapse !important;}
        body, #bodyTable, #bodyCell{height:100% !important; margin:0; padding:0; width:100% !important;}

        <#-- ========== Page Styles ========== -->
        #bodyCell{padding:20px;}
        #templateContainer{width:600px;}
        body, #bodyTable{background-color:#DEE0E2;}
        #bodyCell{border-top:4px solid #BBBBBB;}
        #templateContainer{border:1px solid #BBBBBB;}
        h1{color:#202020 !important;display:block;
            font-family:Helvetica;font-size:20px;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;
            margin-top:8px;margin-right:0;margin-bottom:8px;margin-left:0;text-align:left;
        }
        h2{color:#404040 !important;display:block;
            font-family:Helvetica;font-size:18px;font-style:normal;font-weight:bold;line-height:100%;letter-spacing:normal;
            margin-top:6px;margin-right:0;margin-bottom:6px;margin-left:0;text-align:left;
        }
        h3{color:#606060 !important;display:block;
            font-family:Helvetica;font-size:16px;font-style:italic;font-weight:normal;line-height:100%;letter-spacing:normal;
            margin-top:4px;margin-right:0;margin-bottom:4px;margin-left:0;text-align:left;
        }
        h4{color:#808080 !important;display:block;
            font-family:Helvetica;font-size:14px;font-style:italic;font-weight:normal;line-height:100%;letter-spacing:normal;
            margin-top:4px;margin-right:0;margin-bottom:4px;margin-left:0;text-align:left;
        }

        <#-- ========== Header Styles ========== -->
        <#if preHeaderContent?has_content>
        #templatePreheader{background-color:#F4F4F4;border-bottom:1px solid #CCCCCC;}
        .preheaderContent{color:#808080;font-family:Helvetica;font-size:10px;line-height:125%;text-align:left;}
        .preheaderContent a:link, .preheaderContent a:visited, <#-- Yahoo! Mail Override --> .preheaderContent a .yshortcuts <#-- Yahoo! Mail Override -->{
            color:#606060;font-weight:normal;text-decoration:underline;}
        </#if>
        <#if headerImagePath?has_content>
        #templateHeader{background-color:#F4F4F4;border-top:1px solid #FFFFFF;border-bottom:1px solid #CCCCCC;}
        .headerContent{color:#505050;font-family:Helvetica;font-size:20px;font-weight:bold;line-height:100%;
            padding-top:0;padding-right:0;padding-bottom:0;padding-left:0;text-align:center;vertical-align:middle;}
        .headerContent a:link, .headerContent a:visited, <#-- Yahoo! Mail Override --> .headerContent a .yshortcuts <#-- Yahoo! Mail Override -->{
            color:#428BCA;font-weight:normal;text-decoration:underline; }
        #headerImage{height:auto;max-width:600px;}
        </#if>
        <#-- ========== Body Styles ========== -->
        #templateBody{background-color:#F4F4F4;border-top:1px solid #FFFFFF;border-bottom:1px solid #CCCCCC;}
        .bodyContent{color:#505050;font-family:Helvetica;font-size:14px;line-height:150%;
            padding-top:20px;padding-right:20px;padding-bottom:20px;padding-left:20px;text-align:left; }
        .bodyContent a:link, .bodyContent a:visited, <#-- Yahoo! Mail Override --> .bodyContent a .yshortcuts <#-- Yahoo! Mail Override -->{
            color:#428BCA;font-weight:normal;text-decoration:underline;}
        .bodyContent img{display:inline;height:auto;max-width:560px;}
        <#-- ========== Footer Styles ========== -->
        #templateFooter{background-color:#F4F4F4;border-top:1px solid #FFFFFF;}
        .footerContent{color:#808080;font-family:Helvetica;font-size:10px;line-height:150%;
            padding-top:20px;padding-right:20px;padding-bottom:20px;padding-left:20px;text-align:center;}
        .footerContent a:link, .footerContent a:visited, <#-- Yahoo! Mail Override --> .footerContent a .yshortcuts, .footerContent a span <#-- Yahoo! Mail Override -->{
            color:#606060;font-weight:normal;text-decoration:underline;}

        <#-- MOBILE STYLES -->
        @media only screen and (max-width: 480px){
            <#-- CLIENT-SPECIFIC MOBILE STYLES -->
            body, table, td, p, a, li, blockquote{-webkit-text-size-adjust:none !important;} <#-- Prevent Webkit platforms from changing default text sizes -->
            body{width:100% !important; min-width:100% !important;} <#-- Prevent iOS Mail from adding padding to the body -->
            <#-- MOBILE RESET STYLES -->
            #bodyCell{padding:10px !important;}
            <#-- ======== Page Styles ======== -->
            #templateContainer{max-width:600px !important;width:100% !important;}
            h1{font-size:24px !important;line-height:100% !important;}
            h2{font-size:20px !important;line-height:100% !important;}
            h3{font-size:18px !important;line-height:100% !important;}
            h4{font-size:16px !important;line-height:100% !important;}
            <#-- ======== Header Styles ======== -->
            #templatePreheader{display:none !important;} <#-- Hide the template preheader to save space -->
            #headerImage{height:auto !important;max-width:600px !important;width:100% !important;}
            .headerContent{font-size:20px !important;line-height:125% !important;}
            <#-- ======== Body Styles ======== -->
            .bodyContent{font-size:18px !important;line-height:125% !important;}
            <#-- ======== Footer Styles ======== -->
            .footerContent{font-size:14px !important;line-height:115% !important;}
            .footerContent a{display:block !important;} <#-- Place footer social and utility links on their own lines, for easier access -->
        }
    </style>
</head>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0"><center>
    <table align="center" border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" id="bodyTable"><tr><td align="center" valign="top" id="bodyCell">
        <table border="0" cellpadding="0" cellspacing="0" id="templateContainer">
            <#-- PREHEADER -->
            <#if preHeaderContent?has_content><tr><td align="center" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" id="templatePreheader"><tr>
                    <td valign="top" class="preheaderContent" style="padding-top:10px; padding-right:20px; padding-bottom:10px; padding-left:20px;">
                        <#-- Use this area to offer a short teaser of your email's content. Text here will show in the preview area of some email clients. -->
                        ${preHeaderContent}
                    </td>
                    <#--
                    <td valign="top" width="180" class="preheaderContent" style="padding-top:10px; padding-right:20px; padding-bottom:10px; padding-left:0;">
                        Email not displaying correctly?<br /><a href="*|ARCHIVE|*" target="_blank">View it in your browser</a>.
                    </td>
                    -->
                </tr></table>
            </td></tr></#if>
            <#-- HEADER -->
            <#if headerImagePath?has_content && storeDomain?has_content><tr><td align="center" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateHeader"><tr width="100%"><td valign="top" class="headerContent" align="center" width="100%">
                    <#-- http://gallery.mailchimp.com/2425ea8ad3/images/header_placeholder_600px.png -->
                    <img src="<#if headerImagePath?starts_with("http")>${headerImagePath}<#else>http://${storeDomain}/${headerImagePath}</#if>" alt="Header" title="Header" style="display:block;max-width:600px;" id="headerImage"/>
                </td></tr></table>
            </td></tr></#if>
            <#-- BODY -->
            <tr><td align="center" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateBody"><tr><td valign="top" class="bodyContent">
                    <#--
                    <h1>Designing Your Template</h1>
                    <h3>Creating a good-looking email is simple</h3>
                    Customize your template by clicking on the style editor tabs above. Set your fonts, colors, and styles. After setting your styling is all done you can click here in this area, delete the text, and start adding your own awesome content.
                    <br />
                    <br />
                    <h2>Styling Your Content</h2>
                    <h4>Make your email easy to read</h4>
                    After you enter your content, highlight the text you want to style and select the options you set in the style editor in the "<em>styles</em>" drop down box. Want to <a href="http://www.mailchimp.com/kb/article/im-using-the-style-designer-and-i-cant-get-my-formatting-to-change" target="_blank">get rid of styling on a bit of text</a>, but having trouble doing it? Just use the "<em>remove formatting</em>" button to strip the text of any formatting and reset your style.
                    -->
                    <#if bodyContent?has_content>${bodyContent}</#if>
                    <#if bodyContentLocation?has_content>${sri.renderText(bodyContentLocation, "true")}</#if>
                </td></tr></table>
            </td></tr>
            <#-- FOOTER -->
            <tr><td align="center" valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" id="templateFooter">
                    <tr width="100%"><td valign="top" class="footerContent" style="padding-top:20px;" width="100%">
                        <#if footerContent?has_content>${footerContent}</#if>
                        <#if footerContentLocation?has_content>${sri.renderText(footerContentLocation, "true")}</#if>
                    </td></tr>
                    <#--
                    <tr><td valign="top" class="footerContent">
                        <a href="*|TWITTER:PROFILEURL|*">Follow on Twitter</a>&nbsp;&nbsp;&nbsp;<a href="*|FACEBOOK:PROFILEURL|*">Friend on Facebook</a>&nbsp;&nbsp;&nbsp;<a href="*|FORWARD|*">Forward to Friend</a>&nbsp;
                    </td></tr>
                    <tr><td valign="top" class="footerContent" style="padding-top:0; padding-bottom:40px;">
                        <#if fromName?has_content>
                        <em>Copyright &copy; ${ec.l10n.format(ec.user.nowTimestamp, 'yyyy')} ${fromName}, All rights reserved.</em>
                        <br />
                        <br />
                        </#if>
                    </td></tr>
                    -->
                    <#if profileUrlPath?has_content && storeDomain?has_content>
                        <tr width="100%"><td valign="top" class="footerContent" style="padding-top:0; padding-bottom:40px;" align="center" width="100%">
                            <#--<a href="*|UNSUB|*">unsubscribe from this list</a>&nbsp;&nbsp;&nbsp;-->
                            <a href="<#if profileUrlPath?starts_with("http")>${profileUrlPath}<#else>http://${storeDomain}/${profileUrlPath}</#if>">Profile and Preferences</a>
                        </td></tr>
                    </#if>
                </table>
            </td></tr>
        </table>
    </td></tr></table>
    <#if emailMessageId?has_content && storeDomain?has_content>
        <img src="http://${storeDomain}/email/${emailMessageId}.png" alt="Email" title="Email" style="display:block;" width="1" height="1" border="0"/></#if>
</center></body>
</html>
