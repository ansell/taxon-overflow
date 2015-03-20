package au.org.ala.taxonoverflow

import grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import grails.test.spock.IntegrationSpec
import spock.lang.Shared

/**
 * Created by rui008 on 19/03/15.
 */
class RestAPISpec extends IntegrationSpec {

    static final ISO_8601_DATE_FORMAT = 'yyyy-MM-dd'

    @Shared
    def grailsApplication
    @Shared
    def sessionFactory
    @Shared
    User userMick
    @Shared
    User userKeef
    @Shared
    QuestionService questionService
    @Shared
    UserService userService
    @Shared
    ElasticSearchService elasticSearchService
    @Shared
    SourceService sourceService

    static transactional = false

    def setup() {
        // Clean elasticsearch index
        elasticSearchService.reinitialiseIndex()

        // Initialize users
        userMick = userService.getUserFromUserId('11841')
        userKeef = userService.getUserFromUserId('11842')

        // Initialize the DB
        // 1st question
        questionService.createQuestionFromOccurrence(
                '181718e6-fd3b-4a1b-8b40-3f83fd2965e5',
                QuestionType.IDENTIFICATION,
                ['kangaroo', 'grey'],
                userMick,
                '1st question 1st comment'
        )
        // 2nd question
        questionService.createQuestionFromOccurrence(
                'b185ec97-7155-4207-b8c1-b0f64244f1a7',
                QuestionType.IDENTIFICATION,
                ['kangaroo', 'brown'],
                userKeef,
                '2nd question 1st comment'
        )
        // 3rd question
        questionService.createQuestionFromOccurrence(
                'c9e9589c-383e-4629-8f80-ea7588c4ccb2',
                QuestionType.IDENTIFICATION,
                ['parrot'],
                userMick,
                '3rd question 1st comment'
        )

        sessionFactory.currentSession.flush()
        sessionFactory.currentSession.clear()
        elasticSearchService.processIndexTaskQueue()
    }

    def cleanup() {
        (grailsApplication.getArtefacts("Domain") as List).each {
            it.newInstance().list()*.delete()
        }
        sessionFactory.currentSession.flush()
        sessionFactory.currentSession.clear()

        sourceService.init()
    }

    void "test DB has been initialized"() {
        when:
        List<Question> questionList = Question.findAll()

        then:
        questionList.size() == 3
    }

    void "test adding a new question from biocache occurrence"() {
        given:
        RestBuilder rest = new RestBuilder()

        when:
        RestResponse response = rest.post("http://localhost:8080/${grailsApplication.metadata.'app.name'}/ws/question") {
            json([
                    source      : 'biocache',
                    occurrenceId: 'f6f8a9b8-4d52-49c3-9352-155f154fc96c',
                    userId      : userKeef.alaUserId,
                    tags        : 'octopus, orange',
                    comment     : 'whatever'
            ])
        }

        then:
        response.status == 200
        Question question = Question.findByOccurrenceId('f6f8a9b8-4d52-49c3-9352-155f154fc96c')
        question.tags.each { tag ->
            ['octopus', 'orange'].contains(tag)
        }
        question.comments[0].comment == 'whatever'
        Question.count == 4
    }

}
