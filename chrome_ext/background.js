var current_tab = {};
var counter = 0;

chrome.tabs.onSelectionChanged.addListener(function(tabid){
  chrome.tabs.get(tabid, function(tab){
    current_tab.title = tab.title;
    current_tab.url = tab.url;
    $.ajax({
      url: 'http://localhost:3000/summary/get_summary_num',
      type: 'GET',
      data: 'url=' + tab.url,
      dataType: 'text',
      success: function(data) {
        chrome.browserAction.setBadgeText({text:String(data)});
      },
      error: function(data) {
        alert("失敗");
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
        url: 'http://localhost:3000/summary/get_summary_num',
        type: 'GET',
        data: 'url=' + tab.url,
        dataType: 'text',
        success: function(data) {
          chrome.browserAction.setBadgeText({text:String(data)});
        },
        error: function(data) {
          alert("失敗");
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
    	url: 'http://localhost:3000/summary/get_summary_num',
        type: 'GET',
        data: 'url=' + tab.url,
        dataType: 'text',
        success: function(data) {
          chrome.browserAction.setBadgeText({text:String(data)});
        },
        error: function(data) {
          alert("失敗");
        }
    });
  });
});
