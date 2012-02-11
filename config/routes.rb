CourseManage::Application.routes.draw do

  get '/signup' => 'users#signup'
  get '/signout' => 'users#signout'
  get '/signup_organization' => 'users#signup_organization'

  get '/signup/:action' => 'users'

  match '/course/:lowname/:action' => 'courses'
  get '/admin/courses/:lowname' => 'admin#manage_course'

  match '/:controller/:action'
  match '/:action' => 'site'
  root to: 'site#index'

end
