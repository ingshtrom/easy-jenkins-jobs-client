EJJ.controller 'main-controller', [
  '$scope'
  '$http'
  ($scope, $http) ->
    $scope.templateJobPrefix = ''
    $scope.newJobPrefix = ''
    $scope.baseJenkinsUrl = ''

    $scope.createJobs = () ->
      if _.isEmpty($scope.newJobPrefix)
        $.bootstrapGrowl 'You must specify a new job prefix!', {
          type: 'danger'
          align: 'center'
          width: 'auto'
          allow_dismiss: true
        }
        return

      data =
        jobPrefix: $scope.newJobPrefix

      if !_.isEmpty($scope.templateJobPrefix)
        data.templatePrefix = $scope.templateJobPrefix

      if !_.isEmpty($scope.jenkinsUrl)
        data.jenkinsUrl = $scope.baseJenkinsUrl

      $http.post('/api/jobs/create-from-template', data)
        .success (data, status, headers, config) ->
          $.bootstrapGrowl 'Your jobs were created, as request, my Master...', {
            type: 'success'
            align: 'center'
            width: 'auto'
            allow_dismiss: true
          }
        .error (data, status, headers, config) ->
          $.bootstrapGrowl 'My Master, I could not get your jobs created...I\'m sorry.', {
            type: 'danger'
            align: 'center'
            width: 'auto'
            allow_dismiss: true
          }
]
