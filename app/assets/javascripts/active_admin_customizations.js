$(document).ready(function() {
  $("#data_import_creator_type").on("change", function() {
    $(".polymorphic").hide();
    $("#data_import_creator_id_input_" + this.value).show();
    console.log(this.value);
  });

  console.log($("#data_import_creator_type").val());
});
