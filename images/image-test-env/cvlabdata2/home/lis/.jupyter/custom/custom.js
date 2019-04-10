define([
	'base/js/namespace',
	'base/js/events'
	],
	function(IPython, events) {
		events.on("app_initialized.NotebookApp",
			function () {
				//IPython.Cell.options_default.cm_config.indentUnit = 1;
				IPython.Cell.options_default.cm_config.indentWithTabs = true;
				IPython.Cell.options_default.cm_config.killTrailingSpace = true;
				console.log(IPython.Cell.options_default.cm_config)
			}
		);
	}
);