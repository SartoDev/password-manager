import * as React from "react";
import { View } from "react-native";
import { Button } from "~/components/ui/button";
import {
  Card,
  CardContent,
  CardFooter,
} from "~/components/ui/card";
import { Text } from "~/components/ui/text";
import { Input } from "~/components/ui/input";
import { Label } from "~/components/ui/label";
import { Separator } from "~/components/ui/separator";

export default function Login() {
  return (
    <View className="flex-1 justify-center items-center bg-secondary/30">
      <Card className="w-full max-w-sm p-6 rounded-2xl">
        <CardContent className="flex-col gap-4 items-end">
          <Input
            className="w-full"
            placeholder="Username"
            aria-labelledby="username"
            aria-errormessage="inputError"
          />
          <Input
            className="w-full"
            placeholder="Password"
            aria-labelledby="username"
            aria-errormessage="inputError"
          />
          <Label>Forget password?</Label>
        </CardContent>
        <CardFooter className="flex-col gap-3 pb-0">
          <Button>
            <Text>Login</Text>
          </Button>
          <Separator></Separator>
          <Text>Doesn't have an account?</Text>
          <Button>
            <Text>Register</Text>
          </Button>
        </CardFooter>
      </Card>
    </View>
  );
}
