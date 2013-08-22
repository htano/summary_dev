var current_tab = {};
chrome.tabs.onSelectionChanged.addListener(function(tabid){
  chrome.tabs.get(tabid, function(tab){
    current_tab.title = tab.title;
    current_tab.url = tab.url;
  });
});

chrome.tabs.onUpdated.addListener( function(tabId, changeInfo, tab) {
  chrome.tabs.getSelected(function(c_tab) {
    if( c_tab.id == tabId && changeInfo.status == "complete" ) {
      current_tab.title = tab.title;
      current_tab.url = tab.url;
    }
  });
});

chrome.windows.onFocusChanged.addListener(function(windowId) {
  chrome.tabs.getSelected(windowId, function(c_tab) {
    current_tab.title = c_tab.title;
    current_tab.url = c_tab.url;
  });
});
