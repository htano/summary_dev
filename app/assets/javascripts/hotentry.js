function clickGoodSummary(summary_id) {
  $.ajax({
    url: '/summary_lists/goodSummaryAjax',
    type: 'GET',
    data: 'summaryId=' + summary_id,
    dataType: 'text',
    success: function(data) {
      if(data == "good") {
        $('#good_summary_img'+summary_id).attr('src', '/images/icons/MunchCancel.png');
        var good_count = $('#good_summary_count'+summary_id).text();
        $('#good_summary_count'+summary_id).text(parseInt(good_count)+1);
      } else if (data == "cancel") {
        $('#good_summary_img'+summary_id).attr('src', '/images/icons/MunchLike.png');
        var good_count = $('#good_summary_count'+summary_id).text();
        $('#good_summary_count'+summary_id).text(parseInt(good_count)-1);
      } else {
        alert(data);
      }
    },
    error: function(data) {
    }
  });
}
