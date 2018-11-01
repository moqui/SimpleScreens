<script src="/../../growerpStatic/js/dragula.min.js"></script>
<link rel="stylesheet" href="/../../growerpStatic/css/dragdropStyle.css" type="text/css"/>
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
            el.className = el.className.replace('ex-moved', '');
        }).on('drop', function (el) { <#-- event when drop item -->
            el.className += ' ex-moved';
        }).on('over', function (el, container) { <#-- event when over on section -->
            container.className += ' ex-over';
        }).on('out', function (el, container) { <#-- event when out to old section -->
            container.className = container.className.replace('ex-over', '');
    });
</script>
<div class="drag-container">
    <ul class="drag-list">
      <#list table as row>
        <#if row.first?exists && row.first == 'yes'>
        <li class="drag-column drag-column-${row.count}">
            <span class="drag-column-header">${row.description}</span>
            <div class="panel-body">
                <div id="${row.statusId}">
        </#if>
        <#if row.partyId?exists>
                    <div class="drag-item" role="alert">
                    <#if row.partyId == "">
                            ${row.combinedName}
                    <#else>
                        <a href="EditLead?partyId=${row.partyId}">${row.combinedName} [${row.partyId}]</a>
                    </#if>
                    </div>
  
        </#if>
        <#if row.first?exists && row.first == 'no'>
                </div>
            </div>
        </li>
        </#if>
     </#list>
    </ul>
</div>
