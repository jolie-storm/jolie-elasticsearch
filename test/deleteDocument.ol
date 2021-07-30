from ..ElasticService import ElasticService

service test{
    embed ElasticService as elastic 

    main{
        setClusterLocation@elastic({
            url = "socket://localhost:9200"
        })()



        deleteDocument@elastic({
            index = "my_index1"
            id = "id1"
        })()


        deleteDocument@elastic({
            index = "my_index1"
            id = "id2"
        })()
    }
}