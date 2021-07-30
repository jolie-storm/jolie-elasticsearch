from ..ElasticService import ElasticService

service test{
    embed ElasticService as elastic 

    main{
        setClusterLocation@elastic({
            url = "socket://localhost:9200"
        })()

        insertDocument@elastic({
            index = "my_index1"
            payload << {name= "balint"
                        surname= "maschio"
                        age = 43}
        })()

        insertDocument@elastic({
            index = "my_index1"
            id = "id1"
            payload << {name= "balint"
                        surname= "maschio"
                        age = 43}
        })()

        insertDocument@elastic({
            index = "my_index1"
            unique = false
            id = "id1"
            payload << {name= "balint"
                        surname= "maschio"
                        age = 43}
        })()
    }
}