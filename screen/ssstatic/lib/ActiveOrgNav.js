define({
    /* This software is in the public domain under CC0 1.0 Universal plus a Grant of Patent License. */
    data: function() { return { activeOrg:null, userOrgList:null } },
    template:
    '<div id="active-org-menu" class="nav navbar-right dropdown">' +
        '<a id="active-org-menu-link" href="#" class="dropdown-toggle btn btn-default btn-sm navbar-btn" data-toggle="dropdown" title="Organization">' +
            '<i class="glyphicon glyphicon-globe"></i> {{activeOrg ? activeOrg.pseudoId : ""}}</a>' +
        '<ul v-if="userOrgList" class="dropdown-menu">' +
            '<li v-if="activeOrg"><a @click.prevent="updateActive(null)">Clear Active Organization</a></li>' +
            '<li v-for="userOrg in userOrgList"><a @click.prevent="updateActive(userOrg.partyId)">{{userOrg.pseudoId}}: {{userOrg.organizationName}}</a></li>' +
        '</ul>' +
    '</div>',
    methods: {
        updateActive: function(partyId) {
            var vm = this;
            $.ajax({ type:'POST', url:'/apps/setPreference', error:moqui.handleAjaxError,
                data:{ moquiSessionToken: this.$root.moquiSessionToken, preferenceKey:'ACTIVE_ORGANIZATION', preferenceValue:partyId },
                success: function() {
                    var orgList = vm.userOrgList;
                    if (partyId) { for (var i=0; i<orgList.length; i++) { if (orgList[i].partyId === partyId) { vm.activeOrg = orgList[i]; break; } } }
                    else { vm.activeOrg = null; }
                    vm.$root.reloadSubscreens();
                }
            });
        }
    },
    mounted: function() {
        $('#active-org-menu-link').tooltip({ placement:'bottom', trigger:'hover' });
        var vm = this;
        $.ajax({ type:"GET", url:(this.$root.appRootPath + '/rest/s1/mantle/my/userOrgInfo'), error:moqui.handleAjaxError,
            success: function(resp) { if (resp) { vm.activeOrg = resp.activeOrg; vm.userOrgList = resp.userOrgList; }}
        });
    }
});
