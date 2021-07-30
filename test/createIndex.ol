from ..ElasticService import ElasticService

service test{
    embed ElasticService as elastic 

    main{
        setClusterLocation@elastic({
            url = "socket://localhost:9200"
        })()

        createIndex@elastic({
            index = "my_index"        
        })()
    }
}