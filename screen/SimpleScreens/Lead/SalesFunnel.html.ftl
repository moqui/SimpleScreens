<link rel="stylesheet" href="/ssstatic/css/dragdropStyle.css" type="text/css"/>
<link rel="stylesheet" href="/ssstatic/css/style.css" type="text/css"/>
<script src="/ssstatic/js/dragula.min.js"></script>
<script>
    <#-- list of section from dragdrop -->
    dragula([
        <#list table as row>
            <#if row.first?exists && row.first == 'yes'>
            document.querySelector('#${row.statusId}')
            </#if>
            <#if row.first?exists && row.first == 'no' && row?has_next>
            ,
            </#if>
        </#list>
        ])
        .on('drag', function (el) { <#-- event when start drag -->
            el.className = el.className.replace(' is-moved', '');
        }).on('drop', function (el, container) { <#-- event when drop item -->
            var partyId = el.id;
            var newStatus = container.id;
            updateStatusParty(partyId, newStatus);
        }).on('over', function (el, container) { <#-- event when over on section -->
            container.className += ' is-over';
        }).on('out', function (el, container) { <#-- event when out to old section -->
            container.className = container.className.replace(' is-over', '');
        });

    function updateStatusParty(partyId, newStatus) {
        var moquiSessionToken = $("#confMoquiSessionToken").val();
        jQuery.ajax({
            url: '/apps/Marketing/Lead/SalesFunnel/updateStatusParty',
            type: 'POST',
            data: {partyId: partyId, newStatus: newStatus, moquiSessionToken: moquiSessionToken},
            success: function(data) {
                // Success
            }
        });
    }
</script>
<div class="drag-container">
    <ul class="drag-list">
      <#list table as row>
        <#if row.first?exists && row.first == 'yes'>
        <li class="drag-column drag-column-${row.count}">
            <span class="drag-column-header">${row.description}</span>
            <div class="panel-body">
                <ul class="drag-inner-list" id="${row.statusId}">
        </#if>
        <#if row.partyId?exists>
            <li class="drag-item sales-funnel-drag" id="${row.partyId}">
                <div class="textIndragList">
                    <#if row.partyId == "">
                        ${row.combinedName}
                    <#else>
                        <a href="EditLead?partyId=${row.partyId}"> [${row.partyId}] </a> ${row.combinedName}
                    </#if>
                </div>
                <div class="icon-section">
                    <#if row.logoImageLocation?has_content>
                        <img class="person-logo" src="/apps/Marketing/Lead/SalesFunnel/image/${row.partyContentId!}">
                    <#elseif row.lastName??>
                        <#assign letterText = row.lastName?cap_first?substring(0,1)>
                        <img class="person-logo" src="/ssstatic/images/letterImages/${letterText!}.png">
                    <#else>
                        <img class="person-logo" src="/ssstatic/images/user.png">
                    </#if>
                </div>
            </li>
        </#if>
        <#if row.first?exists && row.first == 'no'>
        </ul>
            </div>
        </li>
        </#if>
     </#list>
    </ul>
</div>
