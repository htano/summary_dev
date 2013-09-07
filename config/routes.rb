SummaryDev::Application.routes.draw do
  get "hotentry/index"
  get "settings/profile"
  get "settings/profile_edit"
  post "settings/profile_edit_complete"
  get "settings/email"
  get "settings/email_edit"
  get "settings/email_auth"
  post "settings/email_edit_complete"
  get "settings/account"

  get "auth/:provider/callback" => "consumer#oauth_complete"

  get "mypage/index"
  get "mypage/delete_article"
  get "mypage/delete_summary"
  get "mypage/mark_as_read"
  get "mypage/mark_as_unread"
  get "mypage/mark_as_favorite"
  get "mypage/clip"
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

  #for webpage
  get 'summary/:article_id/edit' => 'summary#edit'
  post 'summary/:article_id/edit_confirm' => 'summary#edit_confirm'
  post 'summary/:article_id/edit_complete' => 'summary#edit_complete'
  get 'summary/:article_id' => 'summary#show'
  
  #for chrome extension
  get 'summary_lists/get_summary_num_for_chrome_extension' => 'summary_lists#get_summary_num_for_chrome_extension'
  get 'summary_lists/get_summary_list_for_chrome_extension' => 'summary_lists#get_summary_list_for_chrome_extension'
  #for webpage
  get 'summary_lists/goodSummaryAjax' => 'summary_lists#goodSummaryAjax'
  get 'summary_lists/:articleId' => 'summary_lists#index'
  get 'summary_lists/goodSummary/:listIndex/:summaryId/:articleId' => 'summary_lists#goodSummary'
  get 'summary_lists/cancelGoodSummary/:listIndex/:summaryId/:articleId' => 'summary_lists#cancelGoodSummary'
  get 'summary_lists/isRead/:articleId' => 'summary_lists#isRead'
  get 'summary_lists/cancelIsRead/:articleId' => 'summary_lists#cancelIsRead'
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

  get 'session/consumer/:action' => 'consumer#:action'
  post 'session/consumer/:action' => 'consumer#:action'
end
