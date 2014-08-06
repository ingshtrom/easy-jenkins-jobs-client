EJJ = angular.module 'easy-jenkins-jobs', [
  'ui.bootstrap'
  'ngRoute'
  'ngAnimate'
]

EJJ.config [
  '$routeProvider'
  '$locationProvider'
  ($route, $location) ->
    $route
      .when '/', {templateUrl: 'main.html', controller: 'main-controller'}
      .otherwise {redirectTo: '/'}
    $location.html5Mode true
]