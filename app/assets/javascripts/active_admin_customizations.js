$(document).ready(function() {
  function change_creator(val) {
    $(".polymorphic").hide();
    $(".polymorphic select").prop('disabled', true);
    $("#data_import_creator_id_input_" + val).show();
    $("#data_import_creator_id_input_" + val + " select").prop('disabled', false);
  }

  $("#data_import_creator_type").on("change", function() {
    change_creator(this.value);
  });

  if ($("#data_import_creator_type").val()) {
    change_creator($("#data_import_creator_type").val());
  }
});
