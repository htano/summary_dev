$(function(){ 
  $('#only_summarized').click(function(){
    var isChecked = $('#only_summarized:checked').val();
    if(isChecked){
      $('.entry_box_no_summary').hide(300);
    } else {
      $('.entry_box_no_summary').show(300);
    }
  });
});

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

function clickReadItLater(btn, url, aid) {
  if(url.length) {
    if(btn.className == "read_it_cancel") {
      $.ajax({
        url: '/webpage/delete',
        type: 'GET',
        data: 'article_id=' + aid,
        dataType: 'text',
        success: function(data) {
          btn.className="read_it_later";
          btn.innerHTML="Read later";
          var reading_num = $('#reading_counter'+aid).text();
          $('#reading_counter'+aid).text(parseInt(reading_num) - 1);
        }
      });
    } else {
      $.ajax({
        url: '/webpage/add_for_chrome_extension',
        type: 'GET',
        data: 'url=' + escape(url),
        dataType: 'text',
        success: function(data) {
          btn.className="read_it_cancel";
          btn.innerHTML="Cancel";
          var reading_num = $('#reading_counter'+aid).text();
          $('#reading_counter'+aid).text(parseInt(reading_num) + 1);
        }
      });
    }
  }
}
