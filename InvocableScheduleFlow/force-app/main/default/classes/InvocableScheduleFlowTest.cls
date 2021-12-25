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
@isTest
public class InvocableScheduleFlowTest {
    @isTest static void testInvokeFlowNonFuture() {
        Test.startTest();
        List<InvocableScheduleFlow.Request> requests = new List<InvocableScheduleFlow.Request>();
        InvocableScheduleFlow.Request req = new InvocableScheduleFlow.Request();
        req.flowApiName = 'Dummy_ScheduledFlow';
        req.cronExpression = '0 39 18 23 12 ? 2099';
        req.scheduleJobName = 'TestDummy_ScheduledFlow';
        req.flowNamespace = null;
        req.flowParameterName = 'parameter';
        req.flowParameterValue = 'value from ScheduledFlowTest';
        //req.runInFuture set automatically because not set in parameter
        requests.add(req);
        List<InvocableScheduleFlow.Result> results = InvocableScheduleFlow.invoke(requests);
        System.debug(results[0].jobId);
        Test.stopTest();
    }
    @isTest static void testInvokeFlowFuture() {
        Test.startTest();
        List<InvocableScheduleFlow.Request> requests = new List<InvocableScheduleFlow.Request>();
        InvocableScheduleFlow.Request req = new InvocableScheduleFlow.Request();
        req.flowApiName = 'Dummy_ScheduledFlow';
        req.cronExpression = '0 39 18 23 12 ? 2099';
        req.scheduleJobName = 'TestDummy_ScheduledFlow';
        req.flowNamespace = null;
        req.flowParameterName = 'parameter';
        req.flowParameterValue = 'value from ScheduledFlowTest';
        req.runInFuture = true;
        requests.add(req);
        List<InvocableScheduleFlow.Result> results = InvocableScheduleFlow.invoke(requests);
        System.debug(results[0].jobId);
        Test.stopTest();
    }

}