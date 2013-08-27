SummaryDev::Application.routes.draw do
  get "mypage/index"
  get "mypage/delete"
  get "mypage/reverse_read_flg"
  get "mypage/follow"
  get "mypage/unfollow"

  get "mypage/destroy"

  #for chrome extension
  get 'webpage/get_add_history_for_chrome_extension' => 'webpage#get_add_history_for_chrome_extension'
  get 'webpage/get_current_user_name_for_chrome_extension' => 'webpage#get_current_user_name_for_chrome_extension'
  get 'webpage/add_for_chrome_extension' => 'webpage#add_for_chrome_extension'
  #for webpage
  post 'webpage/add' => 'webpage#add'
  post 'webpage/get_title' => 'webpage#get_title'

  get 'summary/get_summary_num' => 'summary#get_summary_num'
  get 'summary/:article_id/edit' => 'summary#edit'
  post 'summary/:article_id/edit_confirm' => 'summary#edit_confirm'
  post 'summary/:article_id/edit_complete' => 'summary#edit_complete'
  get 'summary/:article_id' => 'summary#show'
  
  get 'summary_lists/:articleId' => 'summary_lists#index'
  get 'summary_lists/goodSummary/:summaryId/:articleId' => 'summary_lists#goodSummary'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  get 'hello' => 'webpage#hello'
  get 'bye.html' => 'webpage#bye'
#  get 'webpage/:id/add' => 'webpage#add'
#  get 'webpage/:id/add_confirm' => 'webpage#add_confirm'

#  get 'summary/:id/:pageid/edit' => 'summary#edit'
#  get 'summary/:id/:pageid' => 'summary#show'
#  post 'summary/:id/:pageid/edit_complete' => 'summary#edit_complete'

  get 'session/consumer/:action' => 'consumer#:action'
  post 'session/consumer/:action' => 'consumer#:action'
end
