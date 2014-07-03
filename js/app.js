(function () {
	var app = angular.module('tasklist', []);

	app.controller('TaskListController', function () {
		var taskList = this;

		taskList.tasks = [
			{text:'Book flight', done:false, duedate:new Date(2014, 7, 12), created:new Date(2014, 1, 1)},
			{text:'Book hotel', done:true, duedate:new Date(2014, 7, 10), created:new Date(2014, 1, 2)},
			{text:'Purchase travel insurance', done:false, duedate:'', created:new Date(2014, 1, 3)},
			{text:'Book car hire', done:true, duedate:new Date(2014, 7, 2), created:new Date(2014, 1, 4)},
			{text:'Purchase holiday money', done:true, duedate:new Date(2014, 7, 1), created:new Date(2014, 1, 5)}
		];

		taskList.addTask = function (task) {
			taskList.task.done = false;
			taskList.task.created = new Date();
			taskList.tasks.push(taskList.task);
			taskList.task = {};
		};

		taskList.deleteTask = function (task) {
			taskList.tasks.splice(taskList.tasks.indexOf(task), 1);
		};
	});

	app.directive('focusInputOn', function ($timeout) {
		return {
			restrict: 'A',
			link: function focusInputOnPostLink(scope, elem, attrs) {
				attrs.$observe('focusInputOn', function (newValue) {
					if (newValue) {
						// since the element will become visible (and focusable) after the next render event, we need to wrap the code in '$timeout'
						$timeout(function () {
							var el = elem[0];
							el.focus();
							el.selectionStart = el.selectionEnd = el.value.length;
						});
					}
				});
			}
		};
	});

})();
