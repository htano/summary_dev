var BLANK = ""
var current_tab = {};
var counter = 0;
var SERVICE_HOSTNAME = "localhost:3000";

chrome.tabs.onSelectionChanged.addListener(function(tabid){
  chrome.tabs.get(tabid, function(tab){
    current_tab.title = tab.title;
    current_tab.url = tab.url;
    $.ajax({
      url: 'http://' + SERVICE_HOSTNAME + '/chrome/get_background_info',
      type: 'GET',
      data: 'url=' + escape(tab.url),
      dataType: 'json',
      success: function(data) {
        chrome.browserAction.setBadgeText({text:String(data.summary_num), tabId:tab.id});
        if (data.user_article_id){
          chrome.browserAction.setBadgeBackgroundColor({color:[190, 190, 190, 255]});
        } else {
          chrome.browserAction.setBadgeBackgroundColor({color:[255, 0, 0, 255]});
        }
      }
    });
  });
});

chrome.tabs.onUpdated.addListener( function(tabId, changeInfo, tab) {
  chrome.tabs.getSelected(function(c_tab) {
    if( c_tab.id == tabId && changeInfo.status == "complete" ) {
      current_tab.title = tab.title;
      current_tab.url = tab.url;
      $.ajax({
        url: 'http://' + SERVICE_HOSTNAME + '/chrome/get_background_info',
        type: 'GET',
        data: 'url=' + escape(tab.url),
        dataType: 'json',
        success: function(data) {
          chrome.browserAction.setBadgeText({text:String(data.summary_num), tabId:tab.id});
          if (data.user_article_id){
            chrome.browserAction.setBadgeBackgroundColor({color:[190, 190, 190, 255]});
          } else {
            chrome.browserAction.setBadgeBackgroundColor({color:[255, 0, 0, 255]});
          }
        }
      });
    }
  });
});

chrome.windows.onFocusChanged.addListener(function(windowId) {
  chrome.tabs.getSelected(windowId, function(c_tab) {
    current_tab.title = c_tab.title;
    current_tab.url = c_tab.url;
    $.ajax({
    	url: 'http://' + SERVICE_HOSTNAME + '/chrome/get_background_info',
        type: 'GET',
        data: 'url=' + escape(c_tab.url),
        dataType: 'json',
        success: function(data) {
          chrome.browserAction.setBadgeText({text:String(data.summary_num), tabId:c_tab.id});
          if (data.user_article_id){
            chrome.browserAction.setBadgeBackgroundColor({color:[190, 190, 190, 255]});
          } else {
            chrome.browserAction.setBadgeBackgroundColor({color:[255, 0, 0, 255]});
          }
        }
    });
  });
});
