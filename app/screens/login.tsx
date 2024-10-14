import { View } from "lucide-react-native";
import React from "react";
import Animated, { LayoutAnimationConfig } from "react-native-reanimated";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "~/components/ui/card";
import { Text } from "~/components/ui/text";

export function Login() {
  const [value, setValue] = React.useState("");

  const onChangeText = (text: string) => {
    setValue(text);
  };

  return (
    <View className="flex-1 justify-center items-center gap-5 p-6 bg-secondary/30">
      <Card className="w-full max-w-sm p-6 rounded-2xl">
        <CardHeader className="items-center">
          <View className="p-3" />
          <CardTitle className="pb-2 text-center">Rick Sanchez</CardTitle>
        </CardHeader>
        <CardContent>
          <View className="flex-row justify-around gap-3">
            <View className="items-center">
              <Text className="text-sm text-muted-foreground">Dimension</Text>
              <Text className="text-xl font-semibold">C-137</Text>
            </View>
            <View className="items-center">
              <Text className="text-sm text-muted-foreground">Age</Text>
              <Text className="text-xl font-semibold">70</Text>
            </View>
            <View className="items-center">
              <Text className="text-sm text-muted-foreground">Species</Text>
              <Text className="text-xl font-semibold">Human</Text>
            </View>
          </View>
        </CardContent>
        <CardFooter className="flex-col gap-3 pb-0">
          <View className="flex-row items-center overflow-hidden"></View>
          <View />
        </CardFooter>
      </Card>
    </View>
  );
}
