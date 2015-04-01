import au.org.ala.taxonoverflow.Source

class BootStrap {

    def elasticSearchService
    def customJSONMarshallers
    def grailsApplication
    def sourceService

    def init = { servletContext ->
        log.info("System Notifications are ${grailsApplication.config.notifications.enabled ? 'ENABLED' : 'DISABLED'}")

        // Reference the service to make sure it's loaded and initialised
        elasticSearchService.ping()
        customJSONMarshallers.register()

        sourceService.init()
    }

    def destroy = {
    }
}
