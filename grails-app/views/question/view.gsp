<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="tomain"/>
        <title>Welcome to Grails</title>

        <style>
        <r:style type="text/css">

            #imageViewer {
                height: 400px;
            }

            .newAnswerDiv {
                border: 1px solid #dddddd;
                border-radius: 4px;
                padding: 10px;
            }

        </r:style>
        </style>


        <r:require module="viewer" />
        <r:require module="flexisel" />

        <r:script>

            var images = [];
            <g:each in="${imageIds}" var="imageId">
                images.push("${imageId}");
            </g:each>

            $(document).ready(function() {

                if (images.length > 0) {
                    imgvwr.viewImage($("#imageViewer"), images[0], {})
                }

                $(".image-thumb").click(function(e) {
                    e.preventDefault();
                    var imageId = $(this).closest("[imageId]").attr("imageId");
                    if (imageId) {
                        imgvwr.viewImage($("#imageViewer"), imageId, {})
                    }
                });
            });

            $(window).load(function() {

                renderAnswers();

                $("#mediaThumbs").flexisel({
                    visibleItems: 3,
                    animationSpeed: 200,
                    autoPlay: false,
                    autoPlaySpeed: 3000,
                    pauseOnHover: true,
                    clone:false,
                    enableResponsiveBreakpoints: true,
                    responsiveBreakpoints: {
                        portrait: {
                            changePoint:480,
                            visibleItems: 1
                        },
                        landscape: {
                            changePoint:640,
                            visibleItems: 2
                        },
                        tablet: {
                            changePoint:768,
                            visibleItems: 3
                        }
                    }
                });
            });

            function renderAnswers() {
                $.ajax("${createLink(action:'answersListFragment', id: question.id)}").done(function(content) {
                    $("#answersDiv").html(content);
                });
            }

            function submitAnswer() {

                var answer = { questionId: ${question.id}, userId: "${userId}" };

                $(".newAnswerDiv .answer-field").each(function() {
                    answer[$(this).attr("id")] = $(this).val();
                });

                if (scientificName) {
                    $.post("${createLink(controller: 'webService', action:'submitAnswer', id:question.id)}", answer, null, "json").done(function(response) {
                        if (response.success) {
                            renderAnswers();
                        } else {
                            alert(response.message);
                        }
                    });
                }
            }

        </r:script>

    </head>
    <body class="content">
        <H3>Question ${question.id}&nbsp;<small>[ <a href="http://biocache.ala.org.au/occurrence/${question.occurrenceId}" target="occurrenceDetails">View record in biocache</a> ]</small></H3>
        <g:if test="${acceptedAnswer}">
            <div class="badge badge-success">An identification has been accepted for this occurrence: ${acceptedAnswer.scientificName}</div>
        </g:if>
        <div class="row-fluid">
            <div class="span8">
                <to:occurrencePropertiesTable title="General" section="" names="occurrence.recordedBy, event.eventDate" occurrence="${occurrence}" />
                <to:occurrencePropertiesTable title="Location" section="location" names="locality, decimalLatitude, decimalLongitude" occurrence="${occurrence}" />
                <to:occurrencePropertiesTable title="Identification" section="classification" names="scientificName" occurrence="${occurrence}" />
                <to:occurrencePropertiesTable title="Remarks" section="occurrence" names="occurrenceRemarks" occurrence="${occurrence}" />
                <div id="answersDiv">
                </div>

                <div class="newAnswerDiv">
                    <to:renderAnswerTemplate question="${question}" />
                </div>
            </div>
            <div class="span4">
                <div id="imageViewer"></div>
                <g:if test="${imageIds?.size() > 1}">
                    <div style="margin-top: 10px">
                        <ul id="mediaThumbs">
                            <g:each in="${imageIds}" var="imageId">
                                <li imageId="${imageId}" ><img class="image-thumb" src="http://images.ala.org.au/image/proxyImageThumbnail?imageId=${imageId}" /></li>
                            </g:each>
                        </ul>
                    </div>
                </g:if>
            </div>
        </div>
    </body>
</html>
