$(function(){ 
  $('#only_summarized').click(function(){
    var isChecked = $('#only_summarized:checked').val();
    if(isChecked){
      $('.entry_box_no_summary').hide(10);
    } else {
      $('.entry_box_no_summary').show(10);
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
    btn.style.display = "none";
    $("#add_page_loader" + aid).show();
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
          btn.style.display = "inline";
          $("#add_page_loader" + aid).hide();
          $("#mark_as_read_btn" + aid).attr('style', "visibility:hidden;");
        }
      });
    } else {
      $.ajax({
        url: '/chrome/add',
        type: 'GET',
        data: 'url=' + escape(url),
        dataType: 'text',
        success: function(data) {
          btn.className="read_it_cancel";
          btn.innerHTML="Cancel";
          var reading_num = $('#reading_counter'+aid).text();
          $('#reading_counter'+aid).text(parseInt(reading_num) + 1);
          btn.style.display = "inline";
          $("#add_page_loader" + aid).hide();
          $("#mark_as_read_btn" + aid).attr('style', "visibility:visible;");
          $("#mark_as_read_btn" + aid).attr('class', "mark_as_read");
          $("#mark_as_read_btn" + aid).text("Mark as read");
        }
      });
    }
  }
}

function clickMarkAsRead(btn, aid) {
  btn.style.display = "none";
  $("#mark_read_loader" + aid).show();
  $.ajax({
    url: '/webpage/mark_as_read',
    type: 'GET',
    data: 'article_id=' + aid,
    dataType: 'text',
    success: function(data) {
      btn.style.display = "inline";
      $("#mark_read_loader" + aid).hide();
      if(data == "mark_as_read") {
        btn.className="mark_as_unread";
        btn.innerHTML="Unread";
      } else {
        btn.className="mark_as_read";
        btn.innerHTML="Mark as read";
      }
    }
  });

}
