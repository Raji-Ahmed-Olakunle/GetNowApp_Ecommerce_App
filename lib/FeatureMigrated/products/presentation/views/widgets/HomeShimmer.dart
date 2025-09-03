import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Homeshimmer extends StatelessWidget {
  const Homeshimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: SingleChildScrollView(
            child: Container(
            
            
                height:MediaQuery.of(context).size.height,
                child:
            
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
              //    child: Container(
              //      height: 200,
              //      decoration: BoxDecoration(
              //        color: Colors.white,
              //          borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30),
              //              bottomRight: Radius.circular(30))
              //      ),
              //
              //
              //    ),
              //  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [


                      Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                        child: Container(width: 150,height: 15,decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10))),
                      ),
                                Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                        child: Container(width:80,height: 15,decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10))
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child:
                  Container(
                      width:double.infinity,
                      height:180,
                      child: ListView.builder(itemCount: 5,scrollDirection: Axis.horizontal,itemBuilder: (context,index)=>
                          Column(children: [
                            Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,child: Container(

                                width: 100,
                                height: 100,
                                margin: EdgeInsets.symmetric(horizontal: 10,
                                    vertical: 0
                                )
                                ,decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)))
                            ),
                            ),
                            Container(decoration: BoxDecoration(
                                border: Border.all(width:2,color: Colors.grey.shade300,),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))),

                                width: 100,
                                height: 80,
                                child:Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment:MainAxisAlignment.center,children: [
                                  Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                                      ,child: Container(margin: EdgeInsets.symmetric(vertical: 10),decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)),width: 80,height: 10,)
                                  ),
                                  Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                                      ,child: Container(decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)),width: 80,height: 10,)
                                  )

                                ])
                            ),
                          ])
                  // Row(
                  //   children:[
                  //     Column(children: [
                  //     Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,child: Container(
                  //
                  //           width: 100,
                  //           height: 100,
                  //           margin: EdgeInsets.symmetric(horizontal: 10,
                  //               vertical: 0
                  //           )
                  //       ,decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //       borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)))
                  //       ),
                  //     ),
                  //       Container(decoration: BoxDecoration(
                  //           border: Border.all(width:2,color: Colors.grey.shade300,),
                  //           borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))),
                  //
                  //         width: 100,
                  //         height: 80,
                  //         child:Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment:MainAxisAlignment.center,children: [
                  //           Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                  //             ,child: Container(margin: EdgeInsets.symmetric(vertical: 10),decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(10)),width: 80,height: 10,)
                  //       ),
                  //           Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                  //               ,child: Container(decoration: BoxDecoration(
                  //                   color: Colors.white,
                  //                   borderRadius: BorderRadius.circular(10)),width: 80,height: 10,)
                  //           )
                  //
                  //         ])
                  //       ),
                  //     ])
                  //     , Column(children: [
                  //       Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,child: Container(
                  //
                  //           width: 100,
                  //           height: 100,
                  //           margin: EdgeInsets.symmetric(horizontal: 10,
                  //               vertical: 0
                  //           )
                  //           ,decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)))
                  //       ),
                  //       ),
                  //       Container(decoration: BoxDecoration(
                  //           border: Border.all(width:2,color: Colors.grey.shade300,),
                  //           borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))),
                  //
                  //           width: 100,
                  //           height: 80,
                  //           child:Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment:MainAxisAlignment.center,children: [
                  //             Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                  //                 ,child: Container(margin: EdgeInsets.symmetric(vertical: 10),decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(10)),width: 80,height: 10,)
                  //             ),
                  //             Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                  //                 ,child: Container(decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(10)),width: 80,height: 10,)
                  //             )
                  //
                  //           ])),
                  //     ])
                  //     , Column(children: [
                  //       Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,child: Container(
                  //
                  //           width: 100,
                  //           height: 100,
                  //           margin: EdgeInsets.symmetric(horizontal: 10,
                  //               vertical: 0
                  //           )
                  //           ,decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)))
                  //       ),
                  //       ),
                  //       Container(decoration: BoxDecoration(
                  //           border: Border.all(width:2,color: Colors.grey.shade300,),
                  //           borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))),
                  //
                  //           width: 100,
                  //           height: 80,
                  //           child:Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment:MainAxisAlignment.center,children: [
                  //             Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                  //                 ,child: Container(margin: EdgeInsets.symmetric(vertical: 10),decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(10)),width: 80,height: 10,)
                  //             ),
                  //             Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                  //                 ,child: Container(decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(10)),width: 80,height: 10,)
                  //             )
                  //
                  //           ])),
                  //     ]),
                  //
                  //
                  //   ]
                  // ),
                ))),
                Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,child:
                Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 10),height: 150.0,decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20))),
                ),
                Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                  child: Container(margin: EdgeInsets.symmetric(horizontal: 10),width:80,height: 15,decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10))
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),

                  child:
                  Container(
                    width:double.infinity,
                    height:400,
                    child: ListView.builder(itemCount: 3,scrollDirection: Axis.horizontal,itemBuilder: (context,index)=>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                              child:  Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),
                                width: 230,
                                height: 130,),
                            ),
                            Container(decoration: BoxDecoration(
                                border: Border.all(width:2,color: Colors.grey.shade300,),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))),

                                width: 230,
                                height: 130,
                                child:Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                                          ,child: Container(decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10)),width: 110,height: 15,)
                                      ), Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                                          ,child: Container(decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10)),width: 40,height: 40,)
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                                          ,child: Container(decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10)),width: 80,height: 10)
                                      ),
                                      Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                                          ,child: Container(decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                              width: 80,
                                              height: 25)
                                      )

                                    ],
                                  )
                                  ,
                                  Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                                      ,child: Container(decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)),width: 110,height: 10,)
                                  )
                                  ,
                                  Shimmer.fromColors(enabled: true,baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100
                                      ,child: Container(decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)),width: 50,height: 25,)
                                  )

                                ]))

                          ],
                        )
                    ),
                  )

                )
            
              ]
            ),
                  ),
          )),

    );
  }
}
