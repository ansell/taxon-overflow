<H3>Identify this occurrence</H3>
<div class="form-horizontal">
    <div class="control-group">
        <label for="scientificName" class="control-label">Scientific Name</label>
        <div class="controls">
            <g:textField class="span8" name="scientificName" value="${answer?.binomial}" />
        </div>
    </div>
    <div class="control-group">
        <label for="description" class="control-label">Remarks</label>
        <div class="controls">
            <g:textArea class="span12" name="description" value="${answer?.description}" />
        </div>
    </div>

    <div class="control-group">
        <div class="controls">
            <button class="btn btn-success" id="btnSubmitAnswer">Submit identification</button>
        </div>
    </div>

</div>

<script>
    $("#btnSubmitAnswer").click(function(e) {
        submitAnswer();
    });
</script>
