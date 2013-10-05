SummaryDev::Application.routes.draw do
  get "search/index"
  get "search/search"
  get "search/search_by_tag"
  get "search/search_by_content"
  get "search/search_by_title"
  get "follow_lists/followers"
  get "follow_lists/following"
  get "follow_lists/suggestion"
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
  get "mypage/mark_off_favorite"
  get "mypage/clip"
  post "mypage/follow"
  post "mypage/unfollow"

  get "mypage/destroy"

  #for chrome extension
  get "chrome/get_summary_num"
  get "chrome/get_summary_list"
  get "chrome/get_recommand_tag"
  get "chrome/get_recent_tag"
  get "chrome/get_add_history"
  get "chrome/get_current_user_name"
  get "chrome/add"
  #for webpage
  get "webpage/add" => "webpage#add"
  post "webpage/add_confirm" => "webpage#add_confirm"
  post "webpage/add_complete" => "webpage#add_complete"
  get "webpage/delete" => "webpage#delete"
  get "webpage/mark_as_read" => "webpage#mark_as_read"

  #for webpage
  get "summary/:article_id/edit" => "summary#edit"
  post "summary/:article_id/edit_complete" => "summary#edit_complete"
  post "summary/:article_id/delete" => "summary#delete"
  get "summary/:article_id/get_article_image" => "summary#get_article_image"
  
  #for webpage
  get 'summary_lists/goodSummaryAjax' => 'summary_lists#goodSummaryAjax'
  get 'summary_lists/:articleId' => 'summary_lists#index'
  post 'summary_lists/goodSummary/:listIndex/:summaryId/:articleId' => 'summary_lists#goodSummary'
  post 'summary_lists/cancelGoodSummary/:listIndex/:summaryId/:articleId' => 'summary_lists#cancelGoodSummary'
  post 'summary_lists/isRead/:articleId' => 'summary_lists#isRead'
  post 'summary_lists/cancelIsRead/:articleId' => 'summary_lists#cancelIsRead'
  post 'summary_lists/follow/:listIndex/:follow_user_id' => 'summary_lists#follow'
  post 'summary_lists/unfollow/:listIndex/:unfollow_user_id' => 'summary_lists#unfollow'
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
