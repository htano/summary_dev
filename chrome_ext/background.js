var current_tab = {};
chrome.tabs.onSelectionChanged.addListener(function(tabid){
  chrome.tabs.get(tabid, function(tab){
    current_tab.title = tab.title;
    current_tab.url = tab.url;
    console.info("title: " + tab.title + "\n" + "url: " + tab.url );
  });
});
