package template.petstore;

import com.intuit.karate.junit5.Karate;

class PetstoreRunner {

    @Karate.Test
    Karate runDomain() {
        return Karate.run().relativeTo(getClass())
                .tags("~@wip");
    }
}
