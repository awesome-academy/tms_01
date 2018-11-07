$(document).on('turbolinks:load', function () {
  $('body').on('click', '.add-member', function (event) {
    var courseId = $('#course-id').val();
    var checkBoxs = $('.user-remaining');
    var usersChecked = [];
    checkBoxs.each(function (index, el) {
      if (el.checked) {
        var idUser = $(this).val();
        usersChecked.push(idUser);
      }
    });
    if (usersChecked.length == 0) {
      alert(I18n.t("alert.pls_choose_member"));
    } else {
      $.ajax({
        url: '/courses/add_member',
        type: 'GET',
        data: {
          usersChecked: usersChecked,
          courseId: courseId
        },
        success: function (data) {
          if (data.status == 404) {
            alert(I18n.t("alert.course_not_found"));
          } else if (data.status == 403) {
            alert(I18n.t("alert.user_not_found"));
          } else {
            alert(I18n.t("alert.add_member_success"));
          }
        }
      });
    }
  });

  $('body').on('click', '.add-subject', function (event) {
    var listSubject = $('.subject-remaining');
    var subjectsChecked = [];
    var courseId = $('#course-id').val();
    listSubject.each(function (index, el) {
      if (el.checked) {
        var idSubject = $(this).val();
        subjectsChecked.push(idSubject);
      }
    });
    if (subjectsChecked.length == 0) {
      alert(I18n.t("alert.pls_choose_subject"));
    } else {
      $.ajax({
        url: '/courses/add_subject',
        type: 'GET',
        data: {
          subjectsId: subjectsChecked,
          courseId: courseId
        },
        success: function (data) {
          if (data.message != undefined) {
            alert(data.message);
          }
        }
      })
    }
  });
});
