/*
 * @author: Munawir
 * @authorEmail: munawirrahman@gmail.com
 * @authorMedium: https://medium.com/@munawirrahman
 * @description: 
 		Schedule a flow dynamically (can be triggered from other flow or apex anonymous window)
 * @inputs:
 		* flowApiName : the API name of the flow you want to schedule
        * cronExpression : the cron expression for scheduling
        * scheduleJobName : the unique name for the job you want to run
        * flowNamespace : the namespace of the flow you want to schedule
        * flowParameterName : the parameter name you want to pass to the flow e.g : recordId
        * flowParameterValue : the parameter value you want to pass to the flow e.g : 001xxxxxxxxx
        * runInFuture : the parameter decides whether your flow will run in future method or not, this will allow you to do callout before DML transaction in the flow
 * @outputs:
		* jobId : the job id of the job you run
 * @testClass :
        * InvocableScheduleFlowTest (100% coverage for InvocableScheduleFlow and ScheduledFlow)
 * @scriptForApexAnonymous :
        List<InvocableScheduleFlow.Request> requests = new List<InvocableScheduleFlow.Request>();
        InvocableScheduleFlow.Request req = new InvocableScheduleFlow.Request();
        req.flowApiName = 'Dummy_ScheduledFlow'; //mandatory
        req.cronExpression = '0 39 18 23 12 ? 2099'; //mandatory
        req.scheduleJobName = 'TestDummy_ScheduledFlow'; //mandatory
        req.flowNamespace = null; //optional
        req.flowParameterName = 'parameter'; //optional
        req.flowParameterValue = 'value from ScheduledFlowTest'; //optional
        req.runInFuture = false; //will set to false if null or not set
        requests.add(req);
        List<InvocableScheduleFlow.Result> results = InvocableScheduleFlow.invoke(requests);
        System.debug(results[0].jobId); //the job id result
*/
global class ScheduledFlow implements Schedulable{
    global String flowNamespace;
    global String flowApiName;
    global String flowParameterName;
    global String flowParameterValue;
    global Boolean runInFuture;

    global void execute(SchedulableContext SC) {
        if(this.runInFuture){
            executeFutureFlow(this.flowParameterName,this.flowParameterValue,this.flowNamespace,this.flowApiName);
        }
        else{
            executeFlow(this.flowParameterName,this.flowParameterValue,this.flowNamespace,this.flowApiName);
        }
        abortFinalJob(SC.getTriggerId());
    }
    @future(callout=true)
    global static void executeFutureFlow(String flowParameterName, String flowParameterValue, String flowNamespace, String flowApiName){
        executeFlow(flowParameterName, flowParameterValue, flowNamespace, flowApiName);
    }

    global static void executeFlow(String flowParameterName, String flowParameterValue, String flowNamespace, String flowApiName){
        Map<String,Object> inputVariablesMap = new Map<String,Object>();
        if(flowParameterName != null){
            inputVariablesMap.put(flowParameterName,flowParameterValue);
        }
        Flow.Interview myFlow = Flow.Interview.createInterview(flowNamespace,flowApiName,inputVariablesMap);
        myFlow.start();
    }
    // abort job if there's no NextFireTime
    private void abortFinalJob(Id jobId){
        CronTrigger ct = [SELECT Id, NextFireTime FROM CronTrigger WHERE Id =:jobId];
        if(ct.NextFireTime == null || Test.isRunningTest()){
            System.abortJob(jobId);
        }
    }
 }