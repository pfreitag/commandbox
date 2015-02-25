/**
* Create a new interceptor BDD test in an existing ColdBox application.  Make sure you are running this command in the root
* of your app for it to find the correct folder.
* .
* {code:bash}
* coldbox create interceptor-test interceptors.MyInterceptor preProcess,postEvent
* {code}
*
 **/
component extends='commandbox.system.BaseCommand' aliases='' excludeFromHelp=false {

	/**
	* @path The instantiation path of the interceptor to create the test for
	* @points A comma-delimited list of interception points to generate tests for
	* @testsDirectory Your unit tests directory. Only used if tests is true
	**/
	function run( 
		required path,
		points='',
		testsDirectory='tests/specs/interceptors',
	){
		// This will make each directory canonical and absolute
		arguments.testsDirectory = fileSystemUtil.resolvePath( arguments.testsDirectory );

		// Validate directory
		if( !directoryExists( arguments.testsDirectory ) ) {
			directoryCreate( arguments.testsDirectory );
		}

		// This help readability so the success messages aren't up against the previous command line
		print.line();

		// Read in Template
		var interceptorTestContent 	= fileRead( '/commandbox/templates/testing/InterceptorBDDContentScript.txt' );
		var interceptorTestCase 	= fileRead( '/commandbox/templates/testing/InterceptorBDDCaseContentScript.txt' );

		// Start Replacings
		interceptorTestContent = replaceNoCase( interceptorTestContent, "|name|", arguments.name, "all" );

		// Interception Points
		if( len( arguments.points ) ) {
			var allTestsCases = '';
			var thisTestCase = '';
			
			for( var thisPoint in listToArray( arguments.points ) ) {
				thisTestCase = replaceNoCase( interceptorTestCase, '|point|', thisPoint, 'all' );
				allTestsCases &= thisTestCase & CR & CR;
			}
			interceptorTestContent = replaceNoCase( interceptorTestContent, '|TestCases|', allTestsCases, 'all');
		} else {
			interceptorTestContent = replaceNoCase( interceptorTestContent, '|TestCases|', '', 'all');
		}

		// Write it out.
		var testPath = '#arguments.testsDirectory#/#arguments.name#Test.cfc';
		// Create dir if it doesn't exist
		directorycreate( getDirectoryFromPath( testPath ), true, true );
		// Create the tests
		file action='write' file='#testPath#' mode ='777' output='#interceptorTestContent#';
		print.greenLine( 'Created #testPath#' );
	}

}