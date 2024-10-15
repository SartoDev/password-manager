import * as React from "react";
import { Linking, View } from "react-native";
import { Button } from "~/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "~/components/ui/card";
import { Text } from "~/components/ui/text";
import { Input } from "~/components/ui/input";
import { Label } from "~/components/ui/label";

export default function Screen() {
  return (
    <View className="flex-1 justify-center items-center bg-secondary/30">
      <Card className="w-full max-w-sm p-6 rounded-2xl">
        <CardContent className="pt-2 flex-col gap-4 items-end">
          <Input
            className="w-full"
            placeholder="First Name"
            aria-labelledby="username"
            aria-errormessage="inputError"
          />
          <Input
            className="w-full"
            placeholder="Last Name"
            aria-labelledby="username"
            aria-errormessage="inputError"
          />
          <Input
            className="w-full"
            placeholder="Username"
            aria-labelledby="username"
            aria-errormessage="inputError"
          />
          <Input
            className="w-full"
            placeholder="E-mail"
            aria-labelledby="username"
            aria-errormessage="inputError"
          />
          <Input
            className="w-full"
            placeholder="Password"
            aria-labelledby="username"
            aria-errormessage="inputError"
          />
          <Input
            className="w-full"
            placeholder="Repeat Password"
            aria-labelledby="username"
            aria-errormessage="inputError"
          />
        </CardContent>
        <CardFooter className="flex-col gap-3 pb-0">
          <Button>
            <Text>Register</Text>
          </Button>
        </CardFooter>
      </Card>
    </View>
  );
}
