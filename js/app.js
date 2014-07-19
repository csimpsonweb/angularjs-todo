(function () {
	var app = angular.module('tasklist', []);
	var restApiUrl = 'rest/index.cfm?endpoint=/';

	app.controller('TaskListController', ['$http', function ($http) {
		var taskList = this;

		taskList.get = function () {
			taskList.tasks = [];
			$http.get(restApiUrl + 'tasks')
				.success(function(data) {
					taskList.tasks = data;
				});
		};

		taskList.post = function (task) {
			$http.post(restApiUrl + 'tasks/0', task)
				.success(function(data){
					task.done = false;
					taskList.tasks.push(task);
					taskList.errors = {};
					task = {};
				})
				.error(function(data){
					taskList.errors = data;
				});
		};

		taskList.put = function (task) {
			$http.put(restApiUrl + 'tasks/' + task.id, task)
				.success(function(data){
					taskList.errors = {};
					taskList.toggleInput(task);
				})
				.error(function(data){
					taskList.errors = data;
				});
		};

		taskList.delete = function (task) {
			taskList.tasks.splice(taskList.tasks.indexOf(task), 1);
			$http.delete(restApiUrl + 'tasks/' + task.id);
		};

		taskList.toggle = function (task) {
			task.showInput = !task.showInput;
		}

		taskList.get();
	}]);

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
