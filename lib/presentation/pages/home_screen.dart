import "package:cached_network_image/cached_network_image.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter_clean_arch/presentation/viewmodels/home_screen_view_model.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    final viewModel = ref.read(homeScreenViewModelProvider.notifier);
    Future.microtask(() => viewModel.execute("1"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeScreenViewModelProvider);

    if (state.isLoading!) {
      return Center(child: const CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Carousel view
        CarouselSlider(
          options: CarouselOptions(
            animateToClosest: true,
            aspectRatio: 16 / 11,
            autoPlay: true,
          ),
          //items: [],
          items: state.homedetails!.products!
              .map(
                (item) => Card(
                  shadowColor: Colors.grey,
                  elevation: 3,

                  child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Image.network(item.thumbnail!),
                  ),
                ),
              )
              .toList(),
        ),
        // ListView
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.homedetails!.products!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: state.homedetails!.products![index].thumbnail!,
                      width: 100,
                      height: 100,
                      errorWidget: (context, url, object) {
                        return Text("Loading error!");
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.homedetails!.products![index].title!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "\$ ${state.homedetails!.products![index].price}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        //GridView
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: state.homedetails!.products!.length,
            // crossAxisCount: 2,
            // mainAxisCount: 2,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            state.homedetails!.products![index].thumbnail!,
                        height: 110,
                        width: 120,
                        errorWidget: (context, url, error) =>
                            Text("Image loading error"),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.homedetails!.products![index].title!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "\$ ${state.homedetails!.products![index].price}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
