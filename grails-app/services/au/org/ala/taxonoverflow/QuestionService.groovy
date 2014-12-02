package au.org.ala.taxonoverflow

import grails.transaction.NotTransactional
import grails.transaction.Transactional
import org.apache.commons.lang.StringUtils
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class QuestionService {

    def biocacheService

    @NotTransactional
    def boolean questionExists(String occurrenceId) {
        def existing = Question.findByOccurrenceId(occurrenceId)
        return existing != null
    }

    def deleteQuestion(Question question) {
        if (question) {
            question.delete()
        }
    }

    ServiceResult<Question> createQuestionFromOccurrence(String occurrenceId, QuestionType questionType, List<String> tags, User user) {

        def result = new ServiceResult<Question>(success: false)

        def occurrence = biocacheService.getRecord(occurrenceId)

        if (occurrence && (occurrence.raw?.uuid || occurrence.processed?.uuid)) {

            // the id used to search for an occurrence may not be canonical, so
            // once we've found an occurrence, use the canonical id from then on...
            occurrenceId = occurrence.raw?.uuid ?: occurrence.processed?.uuid

            if (validateOccurrenceRecord(occurrenceId, occurrence, result.messages)) {
                def question = new Question(user: user, occurrenceId: occurrenceId, questionType: questionType)
                question.save(failOnError: true)

                // Save the tags
                tags?.each {
                    if (!StringUtils.isEmpty(it)) {
                        def tag = new QuestionTag(question: question, tag: it)
                        tag.save()
                    }
                }

                result.success(question)
            } else {
                result.fail("Failed to validate occurrence record")
            }

        } else {
            result.fail("Unable to retrieve occurrence details for ${occurrenceId}")
        }

        return result
    }

    public boolean validateOccurrenceRecord(String occurrenceId, JSONObject occurrence, List errors) {

        // first check if a question already exists for this occurrence

        if (questionExists(occurrenceId)) {
            errors << "A question already exists for this occurrence"
            return false
        }

        // TODO: Check that the occurrence record is sufficient to create a question (i.e. contains the minimum set of required fields)


        return true
    }

    def deleteAnswer(Answer answer) {
        answer?.delete(flush: true)
    }

    def acceptAnswer(Answer answer) {

        if (!answer) {
            return
        }

        // first check if there any other accepted answers for this question, and if there are, reset them (only one accepted answer at this point)
        def existing = Answer.findAllByQuestionAndAccepted(answer.question, true)
        existing.each { acceptedAnswer ->
            acceptedAnswer.accepted = false
            acceptedAnswer.dateAccepted = new Date()
            acceptedAnswer.save(failOnError: true)
        }

        answer.accepted = true
        answer.save()
    }

    def unacceptAnswer(Answer answer) {

        if (!answer) {
            return
        }

        if (answer.accepted) {
            answer.accepted = false
            answer.dateAccepted = null
            answer.save(failOnError: true)
        }

    }

    def castVoteOnAnswer(Answer answer, User user, VoteType voteType) {

        if (!answer || !user) {
            return
        }

        def vote = AnswerVote.findByAnswerAndUser(answer, user)

        int newVoteValue = voteType == VoteType.Up ? 1 : -1

        if (vote?.voteValue == newVoteValue) {
            voteType = VoteType.Retract
        }


        if (voteType == VoteType.Retract) {
            if (vote) {
                vote.delete()
            }
        } else {
            if (!vote) {
                vote = new AnswerVote(user: user, answer: answer)
            }

            vote.voteValue = newVoteValue
            vote.save(failOnError: true)
        }
    }

    def canUserAcceptAnswer(Answer answer, User user) {
        // If the current user is one who asked the question, they can accept the answer
        if (answer.question.user == user) {
            return true
        }

        return false
    }


    ServiceResult<QuestionComment> addQuestionComment(Question question, User user, String commentText) {
        if (!question) {
            return new ServiceResult<QuestionComment>().fail("No question supplied")
        }
        if (!user) {
            return new ServiceResult<QuestionComment>().fail("No user supplied")
        }

        if (!commentText) {
            return new ServiceResult<QuestionComment>().fail("No comment text supplied")
        }

        def comment = new QuestionComment(question: question, user: user, comment: commentText)
        comment.save(failOnError: true)
        return new ServiceResult<QuestionComment>(result: comment, success: true)
    }

    ServiceResult<AnswerComment> addAnswerComment(Answer answer, User user, String commentText) {
        if (!answer) {
            return new ServiceResult<AnswerComment>().fail("No answer supplied")
        }
        if (!user) {
            return new ServiceResult<AnswerComment>().fail("No user supplied")
        }

        if (!commentText) {
            return new ServiceResult<AnswerComment>().fail("No comment text supplied")
        }

        def comment = new AnswerComment(answer: answer, user: user, comment: commentText)
        comment.save(failOnError: true)
        return new ServiceResult<AnswerComment>(result: comment, success: true)
    }

    ServiceResult<AnswerComment> removeAnswerComment(AnswerComment comment, User user) {
        if (!comment) {
            return new ServiceResult<AnswerComment>().fail("No comment supplied")
        }
        if (!user) {
            return new ServiceResult<AnswerComment>().fail("No user supplied")
        }

        // TODO: check permissions?

        comment.delete(flush: true)
        return new ServiceResult<AnswerComment>(result: comment, success: true)
    }

    ServiceResult<QuestionComment> removeQuestionComment(QuestionComment comment, User user) {
        if (!comment) {
            return new ServiceResult<QuestionComment>().fail("No comment supplied")
        }
        if (!user) {
            return new ServiceResult<QuestionComment>().fail("No user supplied")
        }

        // TODO: check permissions?

        comment.delete(flush: true)
        return new ServiceResult<QuestionComment>(result: comment, success: true)
    }

}
