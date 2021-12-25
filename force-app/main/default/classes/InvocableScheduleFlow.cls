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
public class InvocableScheduleFlow {
    public class Request {
        @InvocableVariable(label = 'Flow API Name' required = True)
        public String flowApiName;
        @InvocableVariable(label = 'Cron Expression' required = True)
        public String cronExpression;
        @InvocableVariable(label = 'Schedule Job Name' required = True)
        public String scheduleJobName;
        @InvocableVariable(label = 'Flow Namespace')
        public String flowNamespace;
        @InvocableVariable(label = 'Flow Parameter / Variable Name')
        public String flowParameterName;
        @InvocableVariable(label = 'Flow Parameter / Variable Value')
        public String flowParameterValue;
        @InvocableVariable(label = 'Run Flow in Future Method, default to False if null')
        public Boolean runInFuture;
    }
    public class Result {
        @InvocableVariable(label = 'Job ID')
        public String jobId;
    }

    @InvocableMethod(label='Invocable Schedule Flow')
    public static List<Result> invoke (List<Request> requests) {
        List<Result> Results = new List<Result>();
        for (Request curRequest : requests) {
            Result result = new Result();
            ScheduledFlow schFlow = setScheduledFlowParams(curRequest);
            result.jobId = System.schedule(curRequest.scheduleJobName, curRequest.cronExpression, schFlow);
            Results.add(result);
        }
        return Results;
    }
    private static scheduledFlow setScheduledFlowParams (Request curRequest) {
        ScheduledFlow schFlow = new ScheduledFlow();
        schFlow.flowApiName = curRequest.flowApiName;
        schFlow.flowNamespace = curRequest.flowNamespace;
        schFlow.flowParameterName = curRequest.flowParameterName;
        schFlow.flowParameterValue = curRequest.flowParameterValue;
        if(curRequest.runInFuture == null){
            schFlow.runInFuture = false;
        }
        else{
            schFlow.runInFuture = curRequest.runInFuture;
        }
        return schFlow;
    }
}