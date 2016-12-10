define({
    /* This software is in the public domain under CC0 1.0 Universal plus a Grant of Patent License. */
    data: function() { return { notificationCount:0, messageCount:0, eventCount:0, taskCount:0 } },
    template:
    '<div class="btn-group navbar-right my-account-nav">' +
        '<m-link href="/apps/my/User/Notifications" data-toggle="tooltip" data-container="body" data-original-title="Notifications" data-placement="bottom" class="btn btn-default btn-sm navbar-btn">' +
            '<i class="glyphicon glyphicon-info-sign"></i> <span class="label label-info">{{notificationCount}}</span></m-link>' +
        '<m-link :href="FindMessageUrl" data-toggle="tooltip" data-container="body" data-original-title="Messages" data-placement="bottom" class="btn btn-default btn-sm navbar-btn">' +
            '<i class="glyphicon glyphicon-envelope"></i> <span class="label label-warning">{{messageCount}}</span></m-link>' +
        '<m-link href="/apps/my/User/Calendar/MyCalendar" data-toggle="tooltip" data-container="body" data-original-title="Events This Week" data-placement="bottom" class="btn btn-default btn-sm navbar-btn">' +
            '<i class="glyphicon glyphicon-calendar"></i> <span class="label label-primary">{{eventCount}}</span></m-link>' +
        '<m-link href="/apps/my/User/Task/MyTasks" data-toggle="tooltip" data-container="body" data-original-title="Open Tasks" data-placement="bottom" class="btn btn-default btn-sm navbar-btn">' +
            '<i class="glyphicon glyphicon-check"></i> <span class="label label-success">{{taskCount}}</span></m-link>' +
    '</div>',
    methods: {
        updateCounts: function() {
            var vm = this; $.ajax({ type:'GET', url:'/apps/my/counts', dataType:'json', success: function(countObj) {
                if (countObj) { vm.notificationCount = countObj.notificationCount; vm.messageCount = countObj.messageCount;
                    vm.eventCount = countObj.eventCount; vm.taskCount = countObj.taskCount; }
            }});
        },
        notificationListener: function(jsonObj, webSocket) {
            // TODO: improve this to look for new message, event, and task notifications and increment their counters (or others to decrement...)
            this.notificationCount++;
        }
    },
    computed: { FindMessageUrl: function() { return '/apps/my/User/Messages/FindMessage?statusId=CeReceived&toPartyId=' + this.$root.partyId; }},
    mounted: function() {
        this.updateCounts(); setInterval(this.updateCounts, 5*60*1000); /* update every 5 minutes */
        $('.my-account-nav [data-toggle="tooltip"]').tooltip();
        this.$root.notificationClient.registerListener("ALL", this.notificationListener);
    }
});

